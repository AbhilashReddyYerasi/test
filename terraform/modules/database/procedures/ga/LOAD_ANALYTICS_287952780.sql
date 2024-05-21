BEGIN
    BEGIN TRANSACTION;
        DELETE FROM RAW.GA.ANALYTICS_287952780
        WHERE
            TO_TIMESTAMP(EVENT_TIMESTAMP) > TO_TIMESTAMP(DATEADD("DAY",
            -2,
            CURRENT_DATE()));
        INSERT INTO RAW.GA.ANALYTICS_287952780 (
            EVENT_DATE,
            EVENT_TIMESTAMP,
            EVENT_NAME,
            NEW_EVENT_PARAMS,
            EVENT_PREVIOUS_TIMESTAMP,
            EVENT_VALUE_IN_USD,
            EVENT_BUNDLE_SEQUENCE_ID,
            EVENT_SERVER_TIMESTAMP_OFFSET,
            USER_ID,
            USER_PSEUDO_ID,
            PRIVACY_INFO,
            NEW_USER_PROPERTIES,
            USER_FIRST_TOUCH_TIMESTAMP,
            USER_LTV,
            DEVICE,
            GEO,
            APP_INFO,
            TRAFFIC_SOURCE,
            STREAM_ID,
            PLATFORM,
            EVENT_DIMENSIONS,
            ECOMMERCE,
            ITEMS,
            LOAD_TS
        )
            SELECT
                T.VAR:event_date::VARCHAR,
                T.VAR:event_timestamp::VARCHAR,
                T.VAR:event_name::VARCHAR,
                RAW.GA."parse_ga4_object_array_func"(T.var:event_params) as NEW_EVENT_PARAMS,
                T.VAR:event_previous_timestamp::VARCHAR,
                T.VAR:event_value_in_usd::NUMBER,
                T.VAR:event_bundle_sequence_id::NUMBER,
                T.VAR:event_server_timestamp_offset::NUMBER,
                T.VAR:user_id::VARCHAR,
                T.VAR:user_pseudo_id::VARCHAR,
                T.VAR:privacy_info::VARIANT,
                RAW.GA."parse_ga4_object_array_func"(T.var:user_properties) as NEW_USER_PROPERTIES,
                T.VAR:user_first_touch_timestamp::VARCHAR,
                T.VAR:user_ltv::VARIANT,
                T.VAR:device::VARIANT,
                T.VAR:geo::VARIANT,
                T.VAR:app_info::VARCHAR,
                T.VAR:traffic_source::VARIANT,
                T.VAR:stream_id::VARCHAR,
                T.VAR:platform::VARCHAR,
                T.VAR:event_dimensions::VARCHAR,
                T.VAR:ecommerce::VARCHAR,
                T.VAR:items::VARCHAR,
                SYSDATE()
            FROM 
                RAW.GA.LOAD_ANALYTICS_287952780_STREAM T;
    COMMIT;
END