BEGIN
    BEGIN TRANSACTION;    
        merge into RAW.DYN.EMAIL_HTML as T
        using (
            select VAR from RAW.DYN.LOAD_EMAIL_HTML_STREAM
            ) as S
            on T.ACTIVITYID = S.VAR:activityid::VARCHAR
        when matched and NOT(
            EQUAL_NULL(T."@ODATA.ETAG", S.VAR:"@odata.etag"::VARCHAR)
            and EQUAL_NULL(T.DESCRIPTION, S.VAR:description::VARCHAR)
            and EQUAL_NULL(T.SAFEDESCRIPTION, S.VAR:safedescription::VARCHAR)
        )
        then update set
            T."@ODATA.ETAG" = S.VAR:"@odata.etag"::VARCHAR,
            T.DESCRIPTION = S.VAR:description::VARCHAR,
            T.SAFEDESCRIPTION = S.VAR:safedescription::VARCHAR,
            T.LOAD_TS = SYSDATE()
        when not matched then insert (
               "@ODATA.ETAG",
                ACTIVITYID,
                DESCRIPTION,
                SAFEDESCRIPTION,
                LOAD_TS
            ) values (
                VAR:"@odata.etag"::VARCHAR(16777216),
                VAR:activityid::VARCHAR(16777216),
                VAR:description::VARCHAR(16777216),
                VAR:safedescription::VARCHAR(16777216),
                SYSDATE()
            );
    COMMIT;
END