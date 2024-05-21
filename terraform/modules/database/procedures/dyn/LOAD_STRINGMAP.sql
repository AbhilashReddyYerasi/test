BEGIN
    BEGIN TRANSACTION;
        DELETE FROM RAW.DYN.STRINGMAP;
        
        INSERT INTO RAW.DYN.STRINGMAP (
            "@ODATA.ETAG",
            VALUE,
            ATTRIBUTENAME,
            VERSIONNUMBER,
            LANGID,
            OBJECTTYPECODE,
            ATTRIBUTEVALUE,
            STRINGMAPID,
            ORGANIZATIONID,
            DISPLAYORDER,
            LOAD_TS
        ) 
            SELECT
                VAR:"@odata.etag"::VARCHAR(16777216),
                VAR:value::VARCHAR(16777216),
                VAR:attributename::VARCHAR(16777216),
                VAR:versionnumber::NUMBER,
                VAR:langid::NUMBER,
                VAR:objecttypecode::VARCHAR(16777216),
                VAR:attributevalue::NUMBER,
                VAR:stringmapid::VARCHAR(16777216),
                VAR:organizationid::VARCHAR(16777216),
                VAR:displayorder::NUMBER,
                SYSDATE()
            FROM 
                RAW.DYN.LOAD_STRINGMAP_STREAM;
    COMMIT;
END