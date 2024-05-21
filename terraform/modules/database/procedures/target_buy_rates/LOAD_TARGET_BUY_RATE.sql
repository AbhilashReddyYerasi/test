BEGIN
    BEGIN TRANSACTION;
        
        INSERT INTO RAW.TARGET_BUY_RATES.TARGET_BUY_RATE (
                DATE_REFERENCE,
                LANE_AREA,
                TARGET_BUY_RATE,
                TARGET_TYPE,
                LOAD_TS
        ) 
        SELECT 
                DATE_REFERENCE::DATE,
                LANE_AREA::VARCHAR,
                TARGET_BUY_RATE::FLOAT,
                TARGET_TYPE::VARCHAR,
                SYSDATE()
        FROM RAW.TARGET_BUY_RATES.LOAD_TARGET_BUY_RATE_STREAM;

    COMMIT;
END
