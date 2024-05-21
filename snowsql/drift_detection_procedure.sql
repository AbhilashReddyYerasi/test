CREATE OR REPLACE PROCEDURE COLUMN_DRIFT()
    RETURNS VARCHAR
    LANGUAGE PYTHON
    RUNTIME_VERSION = '3.8'
    PACKAGES = ('snowflake-snowpark-python')
    HANDLER = 'column_drift'
    EXECUTE AS OWNER
    AS '
import json

from snowflake.snowpark import Session
from snowflake.snowpark.exceptions import SnowparkSQLException
from snowflake.snowpark.functions import call_udf

def column_drift(
    session: Session
):
    copy_history_df = session.sql(f"SELECT STAGE_LOCATION, FILE_NAME, CONCAT_WS( \'.\' , TABLE_CATALOG_NAME, TABLE_SCHEMA_NAME, TABLE_NAME ) AS TABLE_PATH FROM RAW.METADATA.COPY_HISTORY WHERE TABLE_SCHEMA_NAME in (\'CMS\',\'AIRTABLE\') and TIMESTAMPDIFF(\'minutes\', LAST_LOAD_TIME, CURRENT_TIMESTAMP()) < 120 ORDER BY LAST_LOAD_TIME DESC")
    
    error_logs = []

    # tables with no 1 on 1 match between columns in file and table
    excluded_tables = [
        "RAW.DYN.OPPORTUNITY", 
        "RAW.DYN.QUEUE", 
        "RAW.GA.ANALYTICS_287952780", 
        "RAW.GA.ANALYTICS_288010047", 
        "RAW.ORACLE.SUBLEDGER", 
    ]
    
    for row in copy_history_df.to_local_iterator():
        stage_location = row[0]
        file_name = row[1]
        table_path = row[2]

        db, schema, table = table_path.split(".")
        
        if file_name.endswith(".log") or file_name.endswith(".csv") or table_path in excluded_tables:
            continue
        

        table = table.replace("LOAD_", "")
        stages = session.sql(f"show stages in database {db};")
        stages = (
            stages.where(stages[\'"url"\'] == stage_location.strip("/"))
            .where(stages[\'"database_name"\'] == db)
            .where(stages[\'"schema_name"\'] == schema)
            .collect()
        )
        if len(stages) == 0:
            error_info = f"\'Could not find a stage for {table_path}.\'"
            status = "ERROR"
            return_code = 1
        else:
            stage_name = [r["name"] for r in stages][0]

            try:
                path = f"@{db}.{schema}.{stage_name}/{file_name}"
                if file_name.lower().endswith(".avro"):
                    file_columns = session.read.avro(path).columns
                else:
                    file_columns = session.read.parquet(path).columns
                file_columns = {col_name.strip(\'"\').lower() for col_name in file_columns}
                table_columns = session.table(f"{db}.{schema}.{table}").columns
                table_columns = {col_name.strip(\'"\').lower() for col_name in table_columns}
                column_diff = sorted(file_columns - table_columns)
                if len(column_diff) > 0:
                    error_info = f"\'File contains columns that are not in the table: {'', ''.join(column_diff)}\'"
                    status = "ERROR"
                    return_code = 1
                else:
                    error_info = "NULL"
                    status = "OK"
                    return_code = 0
            except SnowparkSQLException as _e:
                error_info = f"\'Could not find table {db}.{schema}.{table}.\'"
                status = "ERROR"
                return_code = 1

        drift_check_status = "RAW.METADATA.COLUMN_DRIFT_STATUS"
        session.sql(
            f"""merge into {drift_check_status} dc using
            (select \'{db}.{schema}.{table}\' as table_name, \'{status}\' as status, {error_info} as error_info, \'{file_name}\' as file_info) new_data
            on dc.table_name = new_data.table_name
            when matched then
                update set status = new_data.status, error_info = new_data.error_info, file_info = new_data.file_info
            when not matched then
            insert values (new_data.table_name, new_data.status, new_data.error_info, new_data.file_info);
            """
        ).collect()
        
        if return_code == 1:
            error_json = {
              "table_name": table_path,
              "stage": stage_location,
              "file_name": file_name,
              "message": error_info
            }
            
            error_logs.append(error_json)
    
    if len(error_logs)> 0:
        df = session.create_dataframe([[0]], schema=["col1"])
        df.select(call_udf("RAW.METADATA.SEND_ERROR", { "message" : error_logs, "subject": "Snowflake Drift Detection" } )).collect()

    return error_logs
';
