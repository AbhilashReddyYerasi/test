
 INSERT INTO RAW.OWD.WEATHER (
    COORD,
    WEATHER,
    BASE,
    MAIN,
    VISIBILITY,
    WIND,
    CLOUDS,
    RAIN,
    SNOW,
    DT,
    SYS,
    TIMEZONE,
    ID,
    NAME,
    COD,
    LOAD_TS
    ) 
    
    SELECT
        VAR:coord::VARIANT,
        VAR:weather::VARIANT,
        VAR:base::VARCHAR,
        VAR:main::VARIANT,
        VAR:visibility::NUMBER,
        VAR:wind::VARIANT,
        VAR:clouds::VARIANT,
        VAR:rain::VARIANT,
        VAR:snow::VARIANT,
        VAR:dt::NUMBER,
        VAR:sys::VARIANT,
        VAR:timezone::NUMBER,
        VAR:id::NUMBER,
        VAR:name::VARCHAR,
        VAR:cod::VARCHAR,
        SYSDATE()
    FROM RAW.OWD.LOAD_WEATHER_STREAM

