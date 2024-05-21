
 INSERT INTO RAW.STREAMING.GPS (
    BODY,
    ENQUEUEDTIMEUTC,
    OFFSET,
    PROPERTIES,
    SEQUENCENUMBER,
    SYSTEMPROPERTIES,
    LOAD_TS
    ) 
    
    SELECT 
        parse_json(hex_decode_string(VAR:Body::VARCHAR)),
        to_timestamp_tz(VAR:EnqueuedTimeUtc::VARCHAR, 'MM/DD/YYYY HH12:MI:SS AM'),
        VAR:Offset::VARCHAR,
        VAR:Properties::VARIANT,
        VAR:SequenceNumber::NUMBER(36,0),
        VAR:SystemProperties::VARIANT,
        sysdate()

    FROM RAW.STREAMING.LOAD_GPS_STREAM
