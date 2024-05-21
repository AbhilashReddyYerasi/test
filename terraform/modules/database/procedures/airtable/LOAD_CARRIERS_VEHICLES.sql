BEGIN
    BEGIN TRANSACTION;
        DELETE FROM RAW.AIRTABLE.CARRIERS_VEHICLES;

        INSERT INTO RAW.AIRTABLE.CARRIERS_VEHICLES (
            ID,
            CREATED_TIME,
            CARRIER,
            VEHICLE_TYPE,
            NUMBER_OF_VEHICLES,
            VRNS,
            FUEL_TYPE,
            STATUS,
            LOAD_TS
        ) SELECT
            VAR:id::VARCHAR AS ID,
            TO_TIMESTAMP_TZ(VAR:createdTime::VARCHAR) AS CREATED_TIME,
            VAR:Carrier::VARCHAR AS CARRIER,
            VAR:VehicleType::VARCHAR AS VEHICLE_TYPE,
            VAR:NumberofVehicles::INTEGER AS NUMBER_OF_VEHICLES,
            VAR:VRNs::VARCHAR AS VRNS,
            VAR:FuelType::VARCHAR AS FUEL_TYPE,
            VAR:Status::VARCHAR AS STATUS,
            SYSDATE()
        FROM RAW.AIRTABLE.LOAD_CARRIERS_VEHICLES_STREAM;

    COMMIT;
END
