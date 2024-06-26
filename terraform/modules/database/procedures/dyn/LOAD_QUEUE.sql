BEGIN
    BEGIN TRANSACTION;
        DELETE FROM RAW.DYN.QUEUE;
        
        INSERT INTO RAW.DYN.QUEUE (
            "@ODATA.ETAG",
            STATECODE,
            MSDYN_QUEUETYPE,
            STATUSCODE,
            INCOMINGEMAILDELIVERYMETHOD,
            QUEUEID,
            DESCRIPTION,
            CREATEDON,
            NUMBEROFMEMBERS,
            _OWNINGTEAM_VALUE,
            NUMBEROFITEMS,
            _OWNERID_VALUE,
            NAME,
            OUTGOINGEMAILDELIVERYMETHOD,
            EMAILROUTERACCESSAPPROVAL,
            VERSIONNUMBER,
            QUEUEVIEWTYPE,
            MSDYN_ISOMNICHANNELQUEUE,
            QUEUETYPECODE,
            _MODIFIEDBY_VALUE,
            MODIFIEDON,
            MSDYN_ISDEFAULTQUEUE,
            ISEMAILADDRESSAPPROVEDBYO365ADMIN,
            _CREATEDBY_VALUE,
            _ORGANIZATIONID_VALUE,
            _OWNINGBUSINESSUNIT_VALUE,
            INCOMINGEMAILFILTERINGMETHOD,
            _DEFAULTMAILBOX_VALUE,
            IGNOREUNSOLICITEDEMAIL,
            _OWNINGUSER_VALUE,
            ENTITYIMAGE_URL,
            _MSDYN_PREQUEUEOVERFLOWRULESETID_VALUE,
            MSDYN_UNIQUENAME,
            _MSDYN_ASSIGNMENTINPUTCONTRACTID_VALUE,
            MSDYN_ASSIGNMENTSTRATEGY,
            _TRANSACTIONCURRENCYID_VALUE,
            OVERRIDDENCREATEDON,
            _MSDYN_OPERATINGHOURID_VALUE,
            EMAILADDRESS,
            IMPORTSEQUENCENUMBER,
            _MODIFIEDONBEHALFBY_VALUE,
            ENTITYIMAGE_TIMESTAMP,
            EXCHANGERATE,
            MSDYN_PRIORITY,
            MSDYN_MAXQUEUESIZE,
            _CREATEDONBEHALFBY_VALUE,
            ENTITYIMAGEID,
            ENTITYIMAGE,
            LOAD_TS
        ) 
            SELECT
                VAR:"@odata.etag"::VARCHAR(16777216),
                VAR:statecode::NUMBER,
                VAR:msdyn_queuetype::NUMBER,
                VAR:statuscode::NUMBER,
                VAR:incomingemaildeliverymethod::NUMBER,
                VAR:queueid::VARCHAR(16777216),
                VAR:description::VARCHAR(16777216),
                VAR:createdon::NUMBER,
                VAR:numberofmembers::NUMBER,
                VAR:_owningteam_value::VARCHAR(16777216),
                VAR:numberofitems::NUMBER,
                VAR:_ownerid_value::VARCHAR(16777216),
                VAR:name::VARCHAR(16777216),
                VAR:outgoingemaildeliverymethod::NUMBER,
                VAR:emailrouteraccessapproval::NUMBER,
                VAR:versionnumber::NUMBER,
                VAR:queueviewtype::NUMBER,
                VAR:msdyn_isomnichannelqueue::BOOLEAN,
                VAR:queuetypecode::NUMBER,
                VAR:_modifiedby_value::VARCHAR(16777216),
                VAR:modifiedon::NUMBER,
                VAR:msdyn_isdefaultqueue::BOOLEAN,
                VAR:isemailaddressapprovedbyo365admin::BOOLEAN,
                VAR:_createdby_value::VARCHAR(16777216),
                VAR:_organizationid_value::VARCHAR(16777216),
                VAR:_owningbusinessunit_value::VARCHAR(16777216),
                VAR:incomingemailfilteringmethod::NUMBER,
                VAR:_defaultmailbox_value::VARCHAR(16777216),
                VAR:ignoreunsolicitedemail::BOOLEAN,
                VAR:_owninguser_value::VARCHAR(16777216),
                VAR:entityimage_url::VARCHAR(16777216),
                VAR:_msdyn_prequeueoverflowrulesetid_value::VARCHAR(16777216),
                VAR:msdyn_uniquename::VARCHAR(16777216),
                VAR:_msdyn_assignmentinputcontractid_value::VARCHAR(16777216),
                VAR:msdyn_assignmentstrategy::VARCHAR(16777216),
                VAR:_transactioncurrencyid_value::VARCHAR(16777216),
                VAR:overriddencreatedon::VARCHAR(16777216),
                VAR:_msdyn_operatinghourid_value::VARCHAR(16777216),
                VAR:emailaddress::VARCHAR(16777216),
                VAR:importsequencenumber::VARCHAR(16777216),
                VAR:_modifiedonbehalfby_value::VARCHAR(16777216),
                VAR:entityimage_timestamp::VARCHAR(16777216),
                VAR:exchangerate::NUMBER,
                VAR:msdyn_priority::NUMBER,
                VAR:msdyn_maxqueuesize::VARCHAR(16777216),
                VAR:_createdonbehalfby_value::VARCHAR(16777216),
                VAR:entityimageid::VARCHAR(16777216),
                VAR:entityimage::VARCHAR(16777216),
                SYSDATE()
            FROM 
                RAW.DYN.LOAD_QUEUE_STREAM;
    COMMIT;
END