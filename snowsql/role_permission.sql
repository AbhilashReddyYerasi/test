-- RAW DB Permissions

-- Analyst Role Permission --
-- Grant USAGE access to all schemas in the database to role analyst
GRANT USAGE ON ALL SCHEMAS IN DATABASE RAW TO ROLE ANALYST;
-- Grant USAGE access to future schemas in the database
GRANT USAGE ON FUTURE SCHEMAS IN DATABASE RAW TO ROLE ANALYST;
-- Grant SELECT access to all tables in the database to role analyst
GRANT SELECT ON ALL TABLES IN DATABASE RAW TO ROLE ANALYST;
-- Grant SELECT access to future tables in the database
GRANT SELECT ON FUTURE TABLES IN DATABASE RAW TO ROLE ANALYST;

-- Analytics DB Permission

-- Analyst Role Permission --
-- Grant USAGE access to all schemas in the database to role analyst
GRANT USAGE ON ALL SCHEMAS IN DATABASE ANALYTICS TO ROLE ANALYST;
-- Grant USAGE access to future schemas in the database
GRANT USAGE ON FUTURE SCHEMAS IN DATABASE ANALYTICS TO ROLE ANALYST;
-- Grant SELECT access to all tables in the database to role analyst
GRANT SELECT ON ALL TABLES IN DATABASE ANALYTICS TO ROLE ANALYST;
-- Grant SELECT access to future tables in the database
GRANT SELECT ON FUTURE TABLES IN DATABASE ANALYTICS TO ROLE ANALYST;


-- Temporary fixes for MX
GRANT USAGE ON DATABASE DEV_MX_ANALYTICS TO ROLE MX_ANALYST;
GRANT CREATE SCHEMA ON DATABASE DEV_MX_ANALYTICS TO ROLE MX_ANALYST;

GRANT USAGE ON DATABASE MX_ANALYTICS TO ROLE MX_ANALYST;
GRANT USAGE ON DATABASE MX_ANALYTICS TO ROLE MX_TRANSFORMER;
GRANT USAGE ON DATABASE MX_ANALYTICS TO ROLE MX_REPORTER;
GRANT CREATE SCHEMA ON DATABASE MX_ANALYTICS TO ROLE MX_TRANSFORMER;
