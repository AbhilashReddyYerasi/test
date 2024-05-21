INSERT INTO RAW.METADATA.COPY_RECORD (
SELECT 
    *
  FROM TABLE(
      INFORMATION_SCHEMA.COPY_HISTORY(TABLE_NAME => 'RAW.CMS.LOAD_CARRIERCOMPANY',
                                      START_TIME=> DATEADD(days,-1,(CURRENT_TIMESTAMP()::date||' 00:00Z')::TIMESTAMP_LTZ),
                                      END_TIME=> (CURRENT_TIMESTAMP()::date||' 00:00Z')::TIMESTAMP_LTZ)
  ) 
  UNION ALL
SELECT 
    *
  FROM TABLE(
      INFORMATION_SCHEMA.COPY_HISTORY(TABLE_NAME => 'RAW.CMS.LOAD_CARRIERCOMPLIANCEREQUIREMENTS',
                                      START_TIME=> DATEADD(days,-1,(CURRENT_TIMESTAMP()::date||' 00:00Z')::TIMESTAMP_LTZ),
                                      END_TIME=> (CURRENT_TIMESTAMP()::date||' 00:00Z')::TIMESTAMP_LTZ)
  ) 
  UNION ALL
SELECT 
    *
  FROM TABLE(
      INFORMATION_SCHEMA.COPY_HISTORY(TABLE_NAME => 'RAW.CMS.LOAD_CARRIERCONTACTDETAILS',
                                      START_TIME=> DATEADD(days,-1,(CURRENT_TIMESTAMP()::date||' 00:00Z')::TIMESTAMP_LTZ),
                                      END_TIME=> (CURRENT_TIMESTAMP()::date||' 00:00Z')::TIMESTAMP_LTZ)
  ) 
  UNION ALL
SELECT 
    *
  FROM TABLE(
      INFORMATION_SCHEMA.COPY_HISTORY(TABLE_NAME => 'RAW.CMS.LOAD_CARRIERCOSTS',
                                      START_TIME=> DATEADD(days,-1,(CURRENT_TIMESTAMP()::date||' 00:00Z')::TIMESTAMP_LTZ),
                                      END_TIME=> (CURRENT_TIMESTAMP()::date||' 00:00Z')::TIMESTAMP_LTZ)
  ) 
  UNION ALL
SELECT 
    *
  FROM TABLE(
      INFORMATION_SCHEMA.COPY_HISTORY(TABLE_NAME => 'RAW.CMS.LOAD_CARRIERFINANCEDETAILS',
                                      START_TIME=> DATEADD(days,-1,(CURRENT_TIMESTAMP()::date||' 00:00Z')::TIMESTAMP_LTZ),
                                      END_TIME=> (CURRENT_TIMESTAMP()::date||' 00:00Z')::TIMESTAMP_LTZ)
  ) 
  UNION ALL
SELECT 
    *
  FROM TABLE(
      INFORMATION_SCHEMA.COPY_HISTORY(TABLE_NAME => 'RAW.CMS.LOAD_CARRIERINVOICES',
                                      START_TIME=> DATEADD(days,-1,(CURRENT_TIMESTAMP()::date||' 00:00Z')::TIMESTAMP_LTZ),
                                      END_TIME=> (CURRENT_TIMESTAMP()::date||' 00:00Z')::TIMESTAMP_LTZ)
  ) 
  UNION ALL
SELECT 
    *
  FROM TABLE(
      INFORMATION_SCHEMA.COPY_HISTORY(TABLE_NAME => 'RAW.CMS.LOAD_CARRIERLIVERATEOFFERS',
                                      START_TIME=> DATEADD(days,-1,(CURRENT_TIMESTAMP()::date||' 00:00Z')::TIMESTAMP_LTZ),
                                      END_TIME=> (CURRENT_TIMESTAMP()::date||' 00:00Z')::TIMESTAMP_LTZ)
  ) 
  UNION ALL
SELECT 
    *
  FROM TABLE(
      INFORMATION_SCHEMA.COPY_HISTORY(TABLE_NAME => 'RAW.CMS.LOAD_CARRIERLIVERATESUBMITTEDOFFERS',
                                      START_TIME=> DATEADD(days,-1,(CURRENT_TIMESTAMP()::date||' 00:00Z')::TIMESTAMP_LTZ),
                                      END_TIME=> (CURRENT_TIMESTAMP()::date||' 00:00Z')::TIMESTAMP_LTZ)
  ) 
  UNION ALL
SELECT 
    *
  FROM TABLE(
      INFORMATION_SCHEMA.COPY_HISTORY(TABLE_NAME => 'RAW.CMS.LOAD_CARRIERTRUCKS',
                                      START_TIME=> DATEADD(days,-1,(CURRENT_TIMESTAMP()::date||' 00:00Z')::TIMESTAMP_LTZ),
                                      END_TIME=> (CURRENT_TIMESTAMP()::date||' 00:00Z')::TIMESTAMP_LTZ)
  ) 
  UNION ALL
SELECT 
    *
  FROM TABLE(
      INFORMATION_SCHEMA.COPY_HISTORY(TABLE_NAME => 'RAW.CMS.LOAD_CARRIERUSERS',
                                      START_TIME=> DATEADD(days,-1,(CURRENT_TIMESTAMP()::date||' 00:00Z')::TIMESTAMP_LTZ),
                                      END_TIME=> (CURRENT_TIMESTAMP()::date||' 00:00Z')::TIMESTAMP_LTZ)
  ) 
  UNION ALL
SELECT 
    *
  FROM TABLE(
      INFORMATION_SCHEMA.COPY_HISTORY(TABLE_NAME => 'RAW.CMS.LOAD_CONTRACTBUYRATEAGREEMENTS',
                                      START_TIME=> DATEADD(days,-1,(CURRENT_TIMESTAMP()::date||' 00:00Z')::TIMESTAMP_LTZ),
                                      END_TIME=> (CURRENT_TIMESTAMP()::date||' 00:00Z')::TIMESTAMP_LTZ)
  ) 
  UNION ALL
SELECT 
    *
  FROM TABLE(
      INFORMATION_SCHEMA.COPY_HISTORY(TABLE_NAME => 'RAW.CMS.LOAD_CONTRACTBUYRATES',
                                      START_TIME=> DATEADD(days,-1,(CURRENT_TIMESTAMP()::date||' 00:00Z')::TIMESTAMP_LTZ),
                                      END_TIME=> (CURRENT_TIMESTAMP()::date||' 00:00Z')::TIMESTAMP_LTZ)
  ) 
  UNION ALL
SELECT 
    *
  FROM TABLE(
      INFORMATION_SCHEMA.COPY_HISTORY(TABLE_NAME => 'RAW.CMS.LOAD_CONTRACTS',
                                      START_TIME=> DATEADD(days,-1,(CURRENT_TIMESTAMP()::date||' 00:00Z')::TIMESTAMP_LTZ),
                                      END_TIME=> (CURRENT_TIMESTAMP()::date||' 00:00Z')::TIMESTAMP_LTZ)
  ) 
  UNION ALL
SELECT 
    *
  FROM TABLE(
      INFORMATION_SCHEMA.COPY_HISTORY(TABLE_NAME => 'RAW.CMS.LOAD_CONTRACTSELLRATEAGREEMENTS',
                                      START_TIME=> DATEADD(days,-1,(CURRENT_TIMESTAMP()::date||' 00:00Z')::TIMESTAMP_LTZ),
                                      END_TIME=> (CURRENT_TIMESTAMP()::date||' 00:00Z')::TIMESTAMP_LTZ)
  ) 
  UNION ALL
SELECT 
    *
  FROM TABLE(
      INFORMATION_SCHEMA.COPY_HISTORY(TABLE_NAME => 'RAW.CMS.LOAD_INVOICES',
                                      START_TIME=> DATEADD(days,-1,(CURRENT_TIMESTAMP()::date||' 00:00Z')::TIMESTAMP_LTZ),
                                      END_TIME=> (CURRENT_TIMESTAMP()::date||' 00:00Z')::TIMESTAMP_LTZ)
  ) 
  UNION ALL
SELECT 
    *
  FROM TABLE(
      INFORMATION_SCHEMA.COPY_HISTORY(TABLE_NAME => 'RAW.CMS.LOAD_JOBFILES',
                                      START_TIME=> DATEADD(days,-1,(CURRENT_TIMESTAMP()::date||' 00:00Z')::TIMESTAMP_LTZ),
                                      END_TIME=> (CURRENT_TIMESTAMP()::date||' 00:00Z')::TIMESTAMP_LTZ)
  ) 
  UNION ALL
SELECT 
    *
  FROM TABLE(
      INFORMATION_SCHEMA.COPY_HISTORY(TABLE_NAME => 'RAW.CMS.LOAD_PROFILEUSERS',
                                      START_TIME=> DATEADD(days,-1,(CURRENT_TIMESTAMP()::date||' 00:00Z')::TIMESTAMP_LTZ),
                                      END_TIME=> (CURRENT_TIMESTAMP()::date||' 00:00Z')::TIMESTAMP_LTZ)
  ) 
  UNION ALL
SELECT 
    *
  FROM TABLE(
      INFORMATION_SCHEMA.COPY_HISTORY(TABLE_NAME => 'RAW.CMS.LOAD_PURCHASEORDERS',
                                      START_TIME=> DATEADD(days,-1,(CURRENT_TIMESTAMP()::date||' 00:00Z')::TIMESTAMP_LTZ),
                                      END_TIME=> (CURRENT_TIMESTAMP()::date||' 00:00Z')::TIMESTAMP_LTZ)
  ) 
  UNION ALL
SELECT 
    *
  FROM TABLE(
      INFORMATION_SCHEMA.COPY_HISTORY(TABLE_NAME => 'RAW.CMS.LOAD_SHIPPERCOSTS',
                                      START_TIME=> DATEADD(days,-1,(CURRENT_TIMESTAMP()::date||' 00:00Z')::TIMESTAMP_LTZ),
                                      END_TIME=> (CURRENT_TIMESTAMP()::date||' 00:00Z')::TIMESTAMP_LTZ)
  ) 
  UNION ALL
SELECT 
    *
  FROM TABLE(
      INFORMATION_SCHEMA.COPY_HISTORY(TABLE_NAME => 'RAW.CMS.LOAD_SHIPPERENTITIES',
                                      START_TIME=> DATEADD(days,-1,(CURRENT_TIMESTAMP()::date||' 00:00Z')::TIMESTAMP_LTZ),
                                      END_TIME=> (CURRENT_TIMESTAMP()::date||' 00:00Z')::TIMESTAMP_LTZ)
  ) 
  UNION ALL
SELECT 
    *
  FROM TABLE(
      INFORMATION_SCHEMA.COPY_HISTORY(TABLE_NAME => 'RAW.CMS.LOAD_SHIPPERINFOS',
                                      START_TIME=> DATEADD(days,-1,(CURRENT_TIMESTAMP()::date||' 00:00Z')::TIMESTAMP_LTZ),
                                      END_TIME=> (CURRENT_TIMESTAMP()::date||' 00:00Z')::TIMESTAMP_LTZ)
  ) 
  UNION ALL
SELECT 
    *
  FROM TABLE(
      INFORMATION_SCHEMA.COPY_HISTORY(TABLE_NAME => 'RAW.CMS.LOAD_SHIPPERPROJECTS',
                                      START_TIME=> DATEADD(days,-1,(CURRENT_TIMESTAMP()::date||' 00:00Z')::TIMESTAMP_LTZ),
                                      END_TIME=> (CURRENT_TIMESTAMP()::date||' 00:00Z')::TIMESTAMP_LTZ)
  ) 
  UNION ALL
SELECT 
    *
  FROM TABLE(
      INFORMATION_SCHEMA.COPY_HISTORY(TABLE_NAME => 'RAW.CMS.LOAD_TRACTIONCONTRACTBUYRATES',
                                      START_TIME=> DATEADD(days,-1,(CURRENT_TIMESTAMP()::date||' 00:00Z')::TIMESTAMP_LTZ),
                                      END_TIME=> (CURRENT_TIMESTAMP()::date||' 00:00Z')::TIMESTAMP_LTZ)
  ) 
  UNION ALL
SELECT 
    *
  FROM TABLE(
      INFORMATION_SCHEMA.COPY_HISTORY(TABLE_NAME => 'RAW.CMS.LOAD_TRACTIONCONTRACTS',
                                      START_TIME=> DATEADD(days,-1,(CURRENT_TIMESTAMP()::date||' 00:00Z')::TIMESTAMP_LTZ),
                                      END_TIME=> (CURRENT_TIMESTAMP()::date||' 00:00Z')::TIMESTAMP_LTZ)
  ) 
  UNION ALL
SELECT 
    *
  FROM TABLE(
      INFORMATION_SCHEMA.COPY_HISTORY(TABLE_NAME => 'RAW.CMS.LOAD_TRANSPORTLOCATIONS',
                                      START_TIME=> DATEADD(days,-1,(CURRENT_TIMESTAMP()::date||' 00:00Z')::TIMESTAMP_LTZ),
                                      END_TIME=> (CURRENT_TIMESTAMP()::date||' 00:00Z')::TIMESTAMP_LTZ)
  ) 
  UNION ALL
SELECT 
    *
  FROM TABLE(
      INFORMATION_SCHEMA.COPY_HISTORY(TABLE_NAME => 'RAW.CMS.LOAD_TRANSPORTLOCATIONSEXT',
                                      START_TIME=> DATEADD(days,-1,(CURRENT_TIMESTAMP()::date||' 00:00Z')::TIMESTAMP_LTZ),
                                      END_TIME=> (CURRENT_TIMESTAMP()::date||' 00:00Z')::TIMESTAMP_LTZ)
  ) 
  UNION ALL
SELECT 
    *
  FROM TABLE(
      INFORMATION_SCHEMA.COPY_HISTORY(TABLE_NAME => 'RAW.CMS.LOAD_TRANSPORTORDERS',
                                      START_TIME=> DATEADD(days,-1,(CURRENT_TIMESTAMP()::date||' 00:00Z')::TIMESTAMP_LTZ),
                                      END_TIME=> (CURRENT_TIMESTAMP()::date||' 00:00Z')::TIMESTAMP_LTZ)
  ) 
  UNION ALL
SELECT 
    *
  FROM TABLE(
      INFORMATION_SCHEMA.COPY_HISTORY(TABLE_NAME => 'RAW.CMS.LOAD_TRANSPORTREFERENCES',
                                      START_TIME=> DATEADD(days,-1,(CURRENT_TIMESTAMP()::date||' 00:00Z')::TIMESTAMP_LTZ),
                                      END_TIME=> (CURRENT_TIMESTAMP()::date||' 00:00Z')::TIMESTAMP_LTZ)
  ) 
  UNION ALL
SELECT 
    *
  FROM TABLE(
      INFORMATION_SCHEMA.COPY_HISTORY(TABLE_NAME => 'RAW.CMS.LOAD_TRANSPORTREQUIREMENTS',
                                      START_TIME=> DATEADD(days,-1,(CURRENT_TIMESTAMP()::date||' 00:00Z')::TIMESTAMP_LTZ),
                                      END_TIME=> (CURRENT_TIMESTAMP()::date||' 00:00Z')::TIMESTAMP_LTZ)
  ) 
  UNION ALL
SELECT 
    *
  FROM TABLE(
      INFORMATION_SCHEMA.COPY_HISTORY(TABLE_NAME => 'RAW.CMS.LOAD_TRANSPORTROUTES',
                                      START_TIME=> DATEADD(days,-1,(CURRENT_TIMESTAMP()::date||' 00:00Z')::TIMESTAMP_LTZ),
                                      END_TIME=> (CURRENT_TIMESTAMP()::date||' 00:00Z')::TIMESTAMP_LTZ)
  ) 
  UNION ALL
SELECT 
    *
  FROM TABLE(
      INFORMATION_SCHEMA.COPY_HISTORY(TABLE_NAME => 'RAW.CMS.LOAD_TRANSPORTSTATUSES',
                                      START_TIME=> DATEADD(days,-1,(CURRENT_TIMESTAMP()::date||' 00:00Z')::TIMESTAMP_LTZ),
                                      END_TIME=> (CURRENT_TIMESTAMP()::date||' 00:00Z')::TIMESTAMP_LTZ)
  ) 
  UNION ALL
SELECT 
    *
  FROM TABLE(
      INFORMATION_SCHEMA.COPY_HISTORY(TABLE_NAME => 'RAW.CMS_AUDIT.LOAD_ADTTRANSPORTORDERS',
                                      START_TIME=> DATEADD(days,-1,(CURRENT_TIMESTAMP()::date||' 00:00Z')::TIMESTAMP_LTZ),
                                      END_TIME=> (CURRENT_TIMESTAMP()::date||' 00:00Z')::TIMESTAMP_LTZ)
  ) 
  UNION ALL
SELECT 
    *
  FROM TABLE(
      INFORMATION_SCHEMA.COPY_HISTORY(TABLE_NAME => 'RAW.CMS_AUDIT.LOAD_OFFERHISTORIES',
                                      START_TIME=> DATEADD(days,-1,(CURRENT_TIMESTAMP()::date||' 00:00Z')::TIMESTAMP_LTZ),
                                      END_TIME=> (CURRENT_TIMESTAMP()::date||' 00:00Z')::TIMESTAMP_LTZ)
  ) 
  UNION ALL
SELECT 
    *
  FROM TABLE(
      INFORMATION_SCHEMA.COPY_HISTORY(TABLE_NAME => 'RAW.CMS_AUDIT.LOAD_OFFERITEMACTIONHISTORIES',
                                      START_TIME=> DATEADD(days,-1,(CURRENT_TIMESTAMP()::date||' 00:00Z')::TIMESTAMP_LTZ),
                                      END_TIME=> (CURRENT_TIMESTAMP()::date||' 00:00Z')::TIMESTAMP_LTZ)
  ) 
  UNION ALL
SELECT 
    *
  FROM TABLE(
      INFORMATION_SCHEMA.COPY_HISTORY(TABLE_NAME => 'RAW.CMS_AUDIT.LOAD_OFFERITEMHISTORIES',
                                      START_TIME=> DATEADD(days,-1,(CURRENT_TIMESTAMP()::date||' 00:00Z')::TIMESTAMP_LTZ),
                                      END_TIME=> (CURRENT_TIMESTAMP()::date||' 00:00Z')::TIMESTAMP_LTZ)
  ) 
)