BEGIN
    BEGIN TRANSACTION;
        DELETE FROM RAW.SP.FUELPRICES; 
        
        INSERT INTO RAW.SP.FUELPRICES (
            FUELPRICE,
            RECORDDATE,
            SOURCE,
            ID,
            CONTENTTYPEID,
            CONTENTTYPE,
            MODIFIED,
            CREATED,
            CREATEDBYID,
            MODIFIEDBYID,
            OWSHIDDENVERSION,
            VERSION,
            PATH,
            COMPLIANCEASSETID,
            LOAD_TS
        ) 
            SELECT
                VAR:FuelPrice::NUMBER,
                VAR:RecordDate::TIMESTAMP_NTZ,
                VAR:Source::VARCHAR,
                VAR:Id::NUMBER,
                VAR:ContentTypeID::VARCHAR,
                VAR:ContentType::VARCHAR,
                VAR:Modified::TIMESTAMP_NTZ,
                VAR:Created::TIMESTAMP_NTZ,
                VAR:CreatedById::NUMBER,
                VAR:ModifiedById::NUMBER,
                VAR:Owshiddenversion::NUMBER,
                VAR:Version::VARCHAR,
                VAR:Path::VARCHAR,
                VAR:ComplianceAssetId::VARCHAR,
                SYSDATE()
            FROM 
                RAW.SP.LOAD_FUELPRICES_STREAM;
    COMMIT;
END
