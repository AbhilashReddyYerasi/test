MERGE INTO RAW.AIRTABLE.CARRIER AS C
USING (
    WITH 
    PARSED_DATA AS (
        SELECT
            VAR:id::VARCHAR AS ID,
            TO_TIMESTAMP_TZ(VAR:createdTime::VARCHAR) AS CREATED_TIME,
            VAR:CarrierDisplayID::VARCHAR AS CARRIER_DISPLAY_ID,
            VAR:CarrierName::VARCHAR AS CARRIER_NAME,
            VAR:CFXServiceProviderGID::NUMBER AS CFX_SERVICE_PROVIDER_GID,
            VAR:CarrierRegion::VARCHAR AS CARRIER_REGION,
            VAR:CarrierManager::VARCHAR AS CARRIER_MANAGER,
            VAR:CarrierDescription::VARCHAR AS CARRIER_DESCRIPTION,
            VAR:CarrierCategory::NUMBER AS CARRIER_CATEGORY,
            VAR:Traction::BOOLEAN AS TRACTION,
            VAR:Curtainsider::BOOLEAN AS CURTAINSIDER,
            VAR:BoxTrailer::BOOLEAN AS BOX_TRAILER,
            VAR:FlatBed::BOOLEAN AS FLAT_BED,
            VAR:Skelly::BOOLEAN AS SKELLY,
            VAR:Moffatt::VARCHAR AS MOFFATT,
            VAR:WasteLicence::BOOLEAN AS WASTE_LICENCE,
            VAR:DVS::VARCHAR AS DVS,
            VAR:CarbonRating::VARCHAR AS CARBON_RATING,
            TO_DATE(VAR:CarbonReviewDate::VARCHAR, 'DD/MM/YYYY') AS CARBON_REVIEW_DATE,
            VAR:IsFactored::BOOLEAN AS IS_FACTORED,
            VAR:DigitalStrategy::VARCHAR AS DIGITAL_STRATEGY,
            VAR:HangingGarment::VARCHAR AS HANGING_GARMENT,
            VAR:IsRestricted::VARCHAR AS IS_RESTRICTED,
            VAR:RestrictedReason::VARCHAR AS RESTRICTED_REASON,
            VAR:TempControlled::BOOLEAN AS TEMP_CONTROLLED,
            VAR:Oversized::BOOLEAN AS OVERSIZED,
            VAR:ADR::BOOLEAN AS ADR,
            VAR:GDP::BOOLEAN AS GDP,
            VAR:FORS::BOOLEAN AS FORS,
            VAR:SecurityCleared::BOOLEAN AS SECURITY_CLEARED,
            VAR:BRC::BOOLEAN AS BRC,
            VAR:ExcludeReminders::FLOAT AS EXCLUDE_REMINDERS,
            VAR:TallCurtainsider::BOOLEAN AS TALL_CURTAINSIDER,
            VAR:IsMonitored::BOOLEAN AS IS_MONITORED,
            VAR:IsFreightForwarder::BOOLEAN AS IS_FREIGHT_FORWARDER,
            VAR:DualTemp::BOOLEAN AS DUAL_TEMP,
            VAR:PerformanceStrikes::FLOAT AS PERFORMANCE_STRIKES
        FROM RAW.AIRTABLE.LOAD_CARRIER_STREAM
    ),
    NEW_STATE AS (
        SELECT *, HASH(*) AS _HASH FROM PARSED_DATA
    ),
    OLD_STATE AS (
        SELECT * FROM RAW.AIRTABLE.CARRIER WHERE _IS_ACTIVE = TRUE
    ),
    DIFF AS (
      SELECT COALESCE(OLD.CARRIER_DISPLAY_ID, NEW.CARRIER_DISPLAY_ID) AS DML_CARRIER_ID,
      OLD.CARRIER_DISPLAY_ID IS NULL AS IS_INSERT,
      NEW.CARRIER_DISPLAY_ID IS NULL AS IS_DELETE,
      (OLD.CARRIER_DISPLAY_ID IS NOT NULL AND NEW.CARRIER_DISPLAY_ID IS NOT NULL AND OLD._HASH <> NEW._HASH) AS IS_UPDATE,
      NEW.*
      FROM NEW_STATE NEW FULL OUTER JOIN OLD_STATE OLD ON OLD.CARRIER_DISPLAY_ID = NEW.CARRIER_DISPLAY_ID
    ),
    DB_CHANGES AS (
      SELECT *, 'INSERT' AS DML FROM DIFF WHERE IS_INSERT = TRUE OR IS_UPDATE = TRUE
      UNION
      SELECT *, 'DELETE' AS DML FROM DIFF WHERE IS_DELETE = TRUE OR IS_UPDATE = TRUE
    )
  SELECT * FROM DB_CHANGES
) AS S
ON C.CARRIER_DISPLAY_ID = S.DML_CARRIER_ID AND S.DML = 'DELETE'
WHEN MATCHED AND C._IS_ACTIVE
THEN UPDATE SET C._VALID_TO = SYSDATE(), C._IS_ACTIVE = FALSE
WHEN NOT MATCHED AND S.DML = 'INSERT' THEN INSERT (
    ID,
    CREATED_TIME,
    CARRIER_DISPLAY_ID,
    CARRIER_NAME,
    CFX_SERVICE_PROVIDER_GID,
    CARRIER_REGION,
    CARRIER_MANAGER,
    CARRIER_DESCRIPTION,
    CARRIER_CATEGORY,
    TRACTION,
    CURTAINSIDER,
    BOX_TRAILER,
    FLAT_BED,
    SKELLY,
    MOFFATT,
    WASTE_LICENCE,
    DVS,
    CARBON_RATING,
    CARBON_REVIEW_DATE,
    IS_FACTORED,
    DIGITAL_STRATEGY,
    HANGING_GARMENT,
    IS_RESTRICTED,
    RESTRICTED_REASON,
    TEMP_CONTROLLED,
    OVERSIZED,
    ADR,
    GDP,
    FORS,
    SECURITY_CLEARED,
    BRC,
    EXCLUDE_REMINDERS,
    TALL_CURTAINSIDER,
    IS_MONITORED,
    IS_FREIGHT_FORWARDER,
    DUAL_TEMP,
    PERFORMANCE_STRIKES,
    _HASH,
    _VALID_FROM,
    _VALID_TO,
    _IS_ACTIVE
) VALUES (
    S.ID,
    S.CREATED_TIME,
    S.CARRIER_DISPLAY_ID,
    S.CARRIER_NAME,
    S.CFX_SERVICE_PROVIDER_GID,
    S.CARRIER_REGION,
    S.CARRIER_MANAGER,
    S.CARRIER_DESCRIPTION,
    S.CARRIER_CATEGORY,
    S.TRACTION,
    S.CURTAINSIDER,
    S.BOX_TRAILER,
    S.FLAT_BED,
    S.SKELLY,
    S.MOFFATT,
    S.WASTE_LICENCE,
    S.DVS,
    S.CARBON_RATING,
    S.CARBON_REVIEW_DATE,
    S.IS_FACTORED,
    S.DIGITAL_STRATEGY,
    S.HANGING_GARMENT,
    S.IS_RESTRICTED,
    S.RESTRICTED_REASON,
    S.TEMP_CONTROLLED,
    S.OVERSIZED,
    S.ADR,
    S.GDP,
    S.FORS,
    S.SECURITY_CLEARED,
    S.BRC,
    S.EXCLUDE_REMINDERS,
    S.TALL_CURTAINSIDER,
    S.IS_MONITORED,
    S.IS_FREIGHT_FORWARDER,
    S.DUAL_TEMP,
    S.PERFORMANCE_STRIKES,
    S._HASH,
    SYSDATE(),
    NULL,
    TRUE
)
