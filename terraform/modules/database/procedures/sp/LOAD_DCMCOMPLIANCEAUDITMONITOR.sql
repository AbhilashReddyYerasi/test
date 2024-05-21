BEGIN
    BEGIN TRANSACTION;
        DELETE FROM RAW.SP.DCMCOMPLIANCEAUDITMONITOR; 
        
        INSERT INTO RAW.SP.DCMCOMPLIANCEAUDITMONITOR (
            ID,
            CONTENTTYPEID,
            CONTENTTYPE,
            SHIPMENTREF,
            MODIFIED,
            CREATED,
            CREATEDBYID,
            MODIFIEDBYID,
            OWSHIDDENVERSION,
            VERSION,
            PATH,
            COMPLIANCEASSETID,
            PROJECT,
            CARRIER,
            SCHDELIVERYDATE,
            PODPASSDATE,
            DOCUMENT,
            COMPLETE,
            FOCUSSED,
            DATE,
            DOCNO,
            LOCATION,
            DOCTORED,
            SDCHECKEDID,
            CMSLINK,
            ADMINCHECKEDID,
            COMMENTS,
            AUDITFAILED,
            INTERNALACTIONVALUE,
            EXTERNALACTIONSVALUE,
            AUDITEDBYID,
            ACTIONSCOMPLETED,
            LOAD_TS
        )
            SELECT
                VAR:Id::NUMBER,
                VAR:ContentTypeID::VARCHAR,
                VAR:ContentType::VARCHAR,
                VAR:ShipmentRef::VARCHAR,
                VAR:Modified::TIMESTAMP_NTZ,
                VAR:Created::TIMESTAMP_NTZ,
                VAR:CreatedById::NUMBER,
                VAR:ModifiedById::NUMBER,
                VAR:Owshiddenversion::NUMBER,
                VAR:Version::VARCHAR,
                VAR:Path::VARCHAR,
                VAR:ComplianceAssetId::VARCHAR,
                VAR:Project::VARCHAR,
                VAR:Carrier::VARCHAR,
                VAR:SchDeliveryDate::TIMESTAMP_NTZ,
                VAR:PODPassDate::TIMESTAMP_NTZ,
                VAR:Document::BOOLEAN,
                VAR:Complete::BOOLEAN,
                VAR:Focussed::BOOLEAN,
                VAR:Date::BOOLEAN,
                VAR:DocNo::BOOLEAN,
                VAR:Location::BOOLEAN,
                VAR:Doctored::BOOLEAN,
                VAR:SDCheckedId::VARCHAR,
                VAR:CMSLink::VARCHAR,
                VAR:AdminCheckedId::NUMBER,
                VAR:Comments::VARCHAR,
                VAR:AuditFailed::BOOLEAN,
                VAR:InternalActionValue::VARCHAR,
                VAR:ExternalActionsValue::VARCHAR,
                VAR:AuditedById::NUMBER,
                VAR:ActionsCompleted::BOOLEAN,
                SYSDATE()
            FROM 
                RAW.SP.LOAD_DCMCOMPLIANCEAUDITMONITOR_STREAM;
    COMMIT;
END
