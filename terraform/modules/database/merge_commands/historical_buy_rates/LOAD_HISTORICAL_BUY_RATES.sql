BEGIN
    BEGIN TRANSACTION;

        INSERT INTO RAW.HISTORICAL_BUY_RATES.HISTORICAL_BUY_RATES (
                LANE_AREA,
                RATE_CARD,
                MONTH_REF,
                LOAD_TS
        ) 
        SELECT 
                LANE_AREA::VARCHAR,
                RATE_CARD::VARCHAR,
                MONTH_REF::VARCHAR,
                SYSDATE()
        FROM RAW.HISTORICAL_BUY_RATES.LOAD_HISTORICAL_BUY_RATES_STREAM;

   COMMIT;
END