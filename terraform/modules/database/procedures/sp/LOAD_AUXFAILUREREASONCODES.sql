BEGIN
    BEGIN TRANSACTION;
        DELETE FROM RAW.SP.AUXFAILUREREASONCODES; 
        
        INSERT INTO RAW.SP.AUXFAILUREREASONCODES (
            ID,
            CONTENTTYPEID,
            CONTENTTYPE,
            PRIMARYREASONCODE,
            MODIFIED,
            CREATED,
            CREATEDBYID,
            MODIFIEDBYID,
            OWSHIDDENVERSION,
            VERSION,
            PATH,
            COMPLIANCEASSETID,
            SECONDARYREASONCODE,
            REASONCODE,
            DESCRIPTION,
            ACTIVE,
            LOAD_TS
        ) 
            SELECT 
                VAR:Id::NUMBER,
                VAR:ContentTypeID::VARCHAR,
                VAR:ContentType::VARCHAR,
                VAR:PrimaryReasonCode::VARCHAR,
                VAR:Modified::TIMESTAMP_NTZ,
                VAR:Created::TIMESTAMP_NTZ,
                VAR:CreatedById::NUMBER,
                VAR:ModifiedById::NUMBER,
                VAR:Owshiddenversion::NUMBER,
                VAR:Version::VARCHAR,
                VAR:Path::VARCHAR,
                VAR:ComplianceAssetId::VARCHAR,
                VAR:SecondaryReasonCode::VARCHAR,
                VAR:ReasonCode::NUMBER,
                VAR:Description::VARCHAR,
                VAR:Active::BOOLEAN,
                SYSDATE()
            FROM 
                RAW.SP.LOAD_AUXFAILUREREASONCODES_STREAM;
    COMMIT;
END
