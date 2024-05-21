MERGE INTO RAW.PHA_FORECAST.PHA_FORECAST AS target
USING (
    SELECT 
        FROM_REGION,
        TO_REGION,
        VOLUME,
        HAULIER,
        FORECAST_DATE,
        SYSDATE() AS LOAD_TS
    FROM RAW.PHA_FORECAST.LOAD_PHA_FORECAST_STREAM
) AS source
ON (
    target.FROM_REGION = source.FROM_REGION
    AND target.TO_REGION = source.TO_REGION
    AND target.HAULIER = source.HAULIER
    AND target.FORECAST_DATE = source.FORECAST_DATE
)
WHEN MATCHED THEN
    UPDATE SET
        target.VOLUME = source.VOLUME,
        target.LOAD_TS = source.LOAD_TS
WHEN NOT MATCHED THEN
    INSERT (
        FROM_REGION,
        TO_REGION,
        VOLUME,
        HAULIER,
        FORECAST_DATE,
        LOAD_TS
    ) VALUES (
        source.FROM_REGION,
        source.TO_REGION,
        source.VOLUME,
        source.HAULIER,
        source.FORECAST_DATE,
        source.LOAD_TS
    )
