BEGIN
    BEGIN TRANSACTION;
        DELETE FROM RAW.AIRTABLE.ASH_ACTUAL;

        INSERT INTO RAW.AIRTABLE.ASH_ACTUAL (
            ID,
            CREATED_TIME,
            VALID_FROM_DATE,
            TYPE,
            VALUE,
            LOAD_TS
        ) SELECT
            VAR:id::VARCHAR AS ID,
            TO_TIMESTAMP_TZ(VAR:createdTime::VARCHAR) AS CREATED_TIME,
            TO_DATE(VAR:ValidfromDate::VARCHAR, 'YYYY-MM-DD') AS VALID_FROM_DATE,
            VAR:Type::VARCHAR AS TYPE,
            VAR:Value::FLOAT AS VALUE,
            SYSDATE()
        FROM RAW.AIRTABLE.LOAD_ASH_ACTUAL_STREAM;

    COMMIT;
END
