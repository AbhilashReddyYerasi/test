module "core" {
  count  = var.core_enabled ? 1 : 0
  source = "./modules/core"

  providers = {
    snowflake.account_admin = snowflake.account_admin
  }

  environment = var.environment

  roles = flatten([{
    name    = "LOADER"
    comment = "Role that is owner of the raw database and use to populate all objects that do the loading and if airflow is used to load that user account will also have this role."
    }, {
    name    = "TRANSFORMER"
    comment = "Role used to transform raw data into consumable data products. Typically for dbt through Airflow."
    }, {
    name    = "MX_TRANSFORMER"
    comment = "Role used to transform raw data into consumable data products. Typically for dbt through Airflow."
    }, {
    name    = "UK_ANALYST"
    comment = "Analyst role for UK"
    }, {
    name    = "REPORTER"
    comment = "Role which can consume the prepared data used to assign to service accounts like for Power BI."
    }, {
    name    = "MX_REPORTER"
    comment = "Role which can consume the prepared data used to assign to service accounts like for Power BI."
    }, {
    name    = "UK_REPORTER"
    comment = "Role which can consume the prepared data used to assign to service accounts like for Power BI."
    }, {
    name    = "ANALYST"
    comment = "Role with read-only access for human interaction with Snowflake. Can read core tables in analytics database (including staging tables) and also the raw tables."
    }, {
    name    = "RAG_SCORING"
    comment = "A DVS-specific role as part of the RAG project."
    },
    {
      name    = "MX_ANALYST"
      comment = "Analyst role for Mexico"
    },
    var.environment != "PROD" ? [{
      name    = "DEVELOPER"
      comment = "Role for developing dbt with large read access and write access to the dev_analytics database."
    }] : []
  ])

  warehouses = [{
    name           = "COMPUTE_WH"
    comment        = "Used for all computations. "
    warehouse_size = "X-small"
    auto_resume    = true
    auto_suspend   = 60
    roles = flatten([
      "LOADER",
      "TRANSFORMER",
      "UK_ANALYST",
      "REPORTER",
      "UK_REPORTER",
      "ANALYST",
      "RAG_SCORING",
      var.environment != "PROD" ? ["DEVELOPER"] : []
    ])
    }, {
    name           = "MX_COMPUTE_WH"
    comment        = "Used by the MX team."
    warehouse_size = "X-small"
    auto_resume    = true
    auto_suspend   = 60
    roles = [
      "MX_TRANSFORMER",
      "MX_REPORTER",
      "MX_ANALYST"
    ]
  }]

  users = [{
    name         = "LOADER"
    login_name   = "LOADER"
    display_name = "LOADER"

    default_warehouse = "COMPUTE_WH"
    default_role      = "LOADER"
    }, {
    name         = "SCHEDULER"
    login_name   = "SCHEDULER"
    display_name = "SCHEDULER"

    default_warehouse = "COMPUTE_WH"
    default_role      = "TRANSFORMER"
    }, {
    name              = "REPORTER"
    login_name        = "REPORTER"
    display_name      = "REPORTER"
    default_warehouse = "COMPUTE_WH"
    default_role      = "REPORTER"
    }, {
    name              = "MX_REPORTER"
    login_name        = "MX_REPORTER"
    display_name      = "MX_REPORTER"
    default_warehouse = "MX_COMPUTE_WH"
    default_role      = "MX_ANALYST"
    },
    {
      name              = "MX_CI"
      login_name        = "MX_CI"
      display_name      = "MX_CI"
      default_warehouse = "MX_COMPUTE_WH"
      default_role      = "MX_ANALYST"
  }]

  owner_role_grants = [{
    current_grants = "COPY"
    on_role_name   = "ANALYST"
    to_role_name   = "AAD_PROVISIONER"
    }, {
    current_grants = "COPY"
    on_role_name   = "MX_ANALYST"
    to_role_name   = "AAD_PROVISIONER"
  }]
}


module "integration" {
  count  = var.integration_enabled ? 1 : 0
  source = "./modules/integration"

  providers = {
    snowflake.loader        = snowflake.loader
    snowflake.account_admin = snowflake.account_admin
  }

  saml_integration = {
    enabled                   = true
    name                      = "saml_integration"
    saml2_provider            = "ADFS"
    saml2_issuer              = "https://sts.windows.net/9a27c3d7-c6aa-4d6d-b8a0-712b8e9d1516/"
    saml2_sso_url             = "https://login.microsoftonline.com/9a27c3d7-c6aa-4d6d-b8a0-712b8e9d1516/saml2"
    saml2_x509_cert           = var.SAML2_X509_CERT
    enabled                   = true
    saml2_enable_sp_initiated = true
    saml2_force_authn         = false
  }

  scim_integration = {
    enabled          = true
    name             = "AAD_PROVISIONING"
    provisioner_role = "AAD_PROVISIONER"
    scim_client      = "AZURE"
    network_policy   = null
  }

  storage_integrations = [{
    name                      = "AZ_STORAGE_INTEGRATION"
    storage_provider          = "AZURE"
    type                      = "EXTERNAL_STAGE"
    azure_tenant_id           = var.azure_tenant_id
    storage_allowed_locations = ["azure://cdr3cx.blob.core.windows.net/cdrblob", "${var.storage_account_url}/dynamics", "${var.storage_account_url}/sharepoint", "${var.storage_account_url}/cms", "${var.storage_account_url}/oracle", "${var.storage_account_url}/google-analytics", "${var.storage_account_url}/finance-forecast", "${var.storage_account_url}/event-hub-shipper-data", "${var.storage_account_url}/open-weather-map", "${var.storage_account_url}/forecast-budget-data", "${var.storage_account_url}/rag-kpi-export", "${var.storage_account_url}/airtable", "${var.storage_account_url}/target-buy-rates", "${var.storage_account_url}/historical-buy-rates", "${var.storage_account_url}/backhaul-matching", "${var.storage_account_url}/pha-forecast", "${var.storage_account_url}/backhaul-airtable", "${var.storage_account_url}/carbon-reporting", "${var.storage_account_url}/cms-temp", "${var.storage_account_url}/zoho-crm", "${var.storage_account_url}/cfx", "${var.storage_account_url}/rate-matrix"]
  }]

  notification_integrations = [{
    name    = "AZ_STORAGE_QUEUE_INTEGRATION"
    enabled = true
    type    = "QUEUE"

    azure_storage_queue_primary_uri = var.storage_queue_url
    azure_tenant_id                 = var.azure_tenant_id
  }]

  api_integration = {
    name                    = "AZ_API"
    api_provider            = "azure_api_management"
    azure_tenant_id         = var.azure_tenant_id
    azure_ad_application_id = var.api_integration_ad_app_id
    api_key                 = var.API_INTEGRATION_API_KEY
    api_allowed_prefixes    = [var.api_management_url]
    enabled                 = true
  }

  # Enterprise or higher subscription needed
  # tags = [{
  #   name           = "tag"
  #   database       = "${var.environment_prefix}RAW"
  #   schema         = "CMS"
  #   allowed_values = ["CMS"]
  # }]

  # Snowflake converts timestamp to a local format, which forces replacement of the resource.
  # In order to change start_timestamp, destroy and recreate the monitor.
  resource_monitors = [
    {
      name            = "account_monitor"
      credit_quota    = 240
      set_for_account = true

      frequency       = "WEEKLY"
      start_timestamp = "2023-11-21 14:50"

      notify_triggers = [80]
      suspend_trigger = 100

      warehouses = null
      }, {
      name            = "warehouse_monitor_1"
      credit_quota    = 40
      set_for_account = false

      frequency       = "DAILY"
      start_timestamp = "2023-11-21 14:50"

      notify_triggers = [80]
      suspend_trigger = 100

      warehouses = [module.core[0].warehouses["COMPUTE_WH"].name]
      }, {
      name            = "warehouse_monitor_mx"
      credit_quota    = 40
      set_for_account = false

      frequency       = "DAILY"
      start_timestamp = "2024-01-13 00:00"

      notify_triggers = [80]
      suspend_trigger = 100

      warehouses = [module.core[0].warehouses["MX_COMPUTE_WH"].name]
    }
  ]
}

module "database" {
  count  = var.database_enabled ? 1 : 0
  source = "./modules/database"

  providers = {
    snowflake.loader        = snowflake.loader
    snowflake.account_admin = snowflake.account_admin
  }

  service_role_name = module.core[0].roles["LOADER"].name
  environment       = var.environment

  databases = flatten([
    {
      name = "RAW"

      pipe_error_integration = "AZ_ERROR_INTEGRATION"

      schemas = flatten([
        {
          name = "DYN"

          stages = [{
            name                = "DYN_STAGE"
            url                 = "${var.storage_account_url}/dynamics"
            storage_integration = module.integration[0].storage_integration["AZ_STORAGE_INTEGRATION"].name

            file_format = "TYPE = PARQUET NULL_IF = []"
          }]

          procedures = [
            {
              name     = "LOAD_ACCOUNT_MERGE_PROC"
              language = "SQL"

              arguments = []

              return_type = "VARIANT"

              statement = file("${path.module}/modules/database/procedures/dyn/LOAD_ACCOUNT.sql")
            },
            {
              name     = "LOAD_CONTACT_MERGE_PROC"
              language = "SQL"

              arguments = []

              return_type = "VARIANT"

              statement = file("${path.module}/modules/database/procedures/dyn/LOAD_CONTACT.sql")
            },
            {
              name     = "LOAD_EMAIL_MERGE_PROC"
              language = "SQL"

              arguments = []

              return_type = "VARIANT"

              statement = file("${path.module}/modules/database/procedures/dyn/LOAD_EMAIL.sql")
            },
            {
              name     = "LOAD_INCIDENT_MERGE_PROC"
              language = "SQL"

              arguments = []

              return_type = "VARIANT"

              statement = file("${path.module}/modules/database/procedures/dyn/LOAD_INCIDENT.sql")
            },
            {
              name     = "LOAD_OPPORTUNITY_MERGE_PROC"
              language = "SQL"

              arguments = []

              return_type = "VARIANT"

              statement = file("${path.module}/modules/database/procedures/dyn/LOAD_OPPORTUNITY.sql")
            },
            {
              name     = "LOAD_QUEUE_MERGE_PROC"
              language = "SQL"

              arguments = []

              return_type = "VARIANT"

              statement = file("${path.module}/modules/database/procedures/dyn/LOAD_QUEUE.sql")
            },
            {
              name     = "LOAD_QUEUEITEM_MERGE_PROC"
              language = "SQL"

              arguments = []

              return_type = "VARIANT"

              statement = file("${path.module}/modules/database/procedures/dyn/LOAD_QUEUEITEM.sql")
            },
            {
              name     = "LOAD_STRINGMAP_MERGE_PROC"
              language = "SQL"

              arguments = []

              return_type = "VARIANT"

              statement = file("${path.module}/modules/database/procedures/dyn/LOAD_STRINGMAP.sql")
            },
            {
              name     = "LOAD_SYSTEMUSER_MERGE_PROC"
              language = "SQL"

              arguments = []

              return_type = "VARIANT"

              statement = file("${path.module}/modules/database/procedures/dyn/LOAD_SYSTEMUSER.sql")
            },
            {
              name     = "LOAD_TASK_MERGE_PROC"
              language = "SQL"

              arguments = []

              return_type = "VARIANT"

              statement = file("${path.module}/modules/database/procedures/dyn/LOAD_TASK.sql")
            },
            {
              name     = "LOAD_TEAM_MERGE_PROC"
              language = "SQL"

              arguments = []

              return_type = "VARIANT"

              statement = file("${path.module}/modules/database/procedures/dyn/LOAD_TEAM.sql")
            },
            {
              name     = "LOAD_EMAIL_HTML_MERGE_PROC"
              language = "SQL"

              arguments = []

              return_type = "VARIANT"

              statement = file("${path.module}/modules/database/procedures/dyn/LOAD_EMAIL_HTML.sql")
            },
          ]

          tables = [
            {
              names = ["LOAD_ACCOUNT", "LOAD_CONTACT", "LOAD_INCIDENT", "LOAD_EMAIL", "LOAD_QUEUEITEM", "LOAD_OPPORTUNITY", "LOAD_TASK", "LOAD_STRINGMAP", "LOAD_SYSTEMUSER", "LOAD_QUEUE", "LOAD_TEAM", "LOAD_EMAIL_HTML"]
              columns = [{
                name = "VAR"
                type = "VARIANT"
              }]

              pipes = {
                file_names = ["account", "contact", "incident", "email", "queueitem", "opportunity", "task", "stringmap", "systemuser", "queue", "team", "html"]

                auto_ingest = true
                integration = "AZ_STORAGE_QUEUE_INTEGRATION"
                stage_name  = "DYN_STAGE"
              }

              streams          = true
              tasks_on_streams = true
              change_tracking  = true

              grants = [{
                privileges = ["SELECT"]
                roles      = [module.core[0].roles["TRANSFORMER"].name]
              }]
            },
            {
              names   = ["CONTACT"]
              columns = jsondecode(file("${path.module}/modules/database/columns/dyn/CONTACT.json"))

              grants = [{
                privileges = ["SELECT"]
                roles      = [module.core[0].roles["TRANSFORMER"].name]
              }]
            },
            {
              names   = ["QUEUEITEM"]
              columns = jsondecode(file("${path.module}/modules/database/columns/dyn/QUEUEITEM.json"))

              grants = [{
                privileges = ["SELECT"]
                roles      = [module.core[0].roles["TRANSFORMER"].name]
              }]
            },
            {
              names   = ["INCIDENT"]
              columns = jsondecode(file("${path.module}/modules/database/columns/dyn/INCIDENT.json"))

              grants = [{
                privileges = ["SELECT"]
                roles      = [module.core[0].roles["TRANSFORMER"].name]
              }]
            },
            {
              names   = ["ACCOUNT"]
              columns = jsondecode(file("${path.module}/modules/database/columns/dyn/ACCOUNT.json"))

              grants = [{
                privileges = ["SELECT"]
                roles      = [module.core[0].roles["TRANSFORMER"].name]
              }]
            },
            {
              names   = ["EMAIL"]
              columns = jsondecode(file("${path.module}/modules/database/columns/dyn/EMAIL.json"))

              grants = [{
                privileges = ["SELECT"]
                roles      = [module.core[0].roles["TRANSFORMER"].name]
              }]
            },
            {
              names   = ["OPPORTUNITY"]
              columns = jsondecode(file("${path.module}/modules/database/columns/dyn/OPPORTUNITY.json"))

              grants = [{
                privileges = ["SELECT"]
                roles      = [module.core[0].roles["TRANSFORMER"].name]
              }]
            },
            {
              names   = ["TASK"]
              columns = jsondecode(file("${path.module}/modules/database/columns/dyn/TASK.json"))

              grants = [{
                privileges = ["SELECT"]
                roles      = [module.core[0].roles["TRANSFORMER"].name]
              }]
            },
            {
              names   = ["STRINGMAP"]
              columns = jsondecode(file("${path.module}/modules/database/columns/dyn/STRINGMAP.json"))

              grants = [{
                privileges = ["SELECT"]
                roles      = [module.core[0].roles["TRANSFORMER"].name]
              }]
            },
            {
              names   = ["SYSTEMUSER"]
              columns = jsondecode(file("${path.module}/modules/database/columns/dyn/SYSTEMUSER.json"))

              grants = [{
                privileges = ["SELECT"]
                roles      = [module.core[0].roles["TRANSFORMER"].name]
              }]
            },
            {
              names   = ["QUEUE"]
              columns = jsondecode(file("${path.module}/modules/database/columns/dyn/QUEUE.json"))

              grants = [{
                privileges = ["SELECT"]
                roles      = [module.core[0].roles["TRANSFORMER"].name]
              }]
            },
            {
              names   = ["TEAM"]
              columns = jsondecode(file("${path.module}/modules/database/columns/dyn/TEAM.json"))

              grants = [{
                privileges = ["SELECT"]
                roles      = [module.core[0].roles["TRANSFORMER"].name]
              }]
            },
            {
              names   = ["EMAIL_HTML"]
              columns = jsondecode(file("${path.module}/modules/database/columns/dyn/EMAIL_HTML.json"))

              grants = [{
                privileges = ["SELECT"]
                roles      = [module.core[0].roles["TRANSFORMER"].name]
              }]
            }
          ]

          grants = [{
            privilege = "USAGE"
            roles     = [module.core[0].roles["TRANSFORMER"].name]
          }]
        },
        {
          name = "OWD"

          stages = [{
            name                = "OWD_STAGE"
            url                 = "${var.storage_account_url}/open-weather-map"
            storage_integration = module.integration[0].storage_integration["AZ_STORAGE_INTEGRATION"].name
            file_format         = "TYPE = PARQUET NULL_IF = []"
          }]

          tables = [
            {
              names = ["LOAD_WEATHER"]
              columns = [{
                name = "VAR"
                type = "VARIANT"
              }]

              pipes = {
                file_names  = ["weather"]
                auto_ingest = true
                integration = "AZ_STORAGE_QUEUE_INTEGRATION"
                stage_name  = "OWD_STAGE"
              }

              streams          = true
              tasks_on_streams = true
              change_tracking  = true

              grants = [{
                privileges = ["SELECT"]
                roles      = [module.core[0].roles["TRANSFORMER"].name]
              }],

            },
            {
              names   = ["WEATHER"]
              columns = jsondecode(file("${path.module}/modules/database/columns/owd/WEATHER.json"))

              grants = [{
                privileges = ["SELECT"]
                roles      = [module.core[0].roles["TRANSFORMER"].name]
              }]
            }
          ]

          grants = [{
            privilege = "USAGE"
            roles     = [module.core[0].roles["TRANSFORMER"].name]
          }]
        },
        {
          name = "STREAMING"

          stages = [{
            name                = "STREAMING_STAGE"
            url                 = "${var.storage_account_url}/event-hub-shipper-data"
            storage_integration = module.integration[0].storage_integration["AZ_STORAGE_INTEGRATION"].name

            file_format = "TYPE = AVRO NULL_IF = []"
          }]

          tables = [
            {
              names = ["LOAD_GPS"]
              columns = [{
                name = "VAR"
                type = "VARIANT"
              }]

              pipes = {
                file_names  = [var.event_hub_filename]
                auto_ingest = true
                integration = "AZ_STORAGE_QUEUE_INTEGRATION"
                stage_name  = "STREAMING_STAGE"
              }

              streams          = true
              tasks_on_streams = false
              change_tracking  = true

              grants = [{
                privileges = ["SELECT"]
                roles      = [module.core[0].roles["TRANSFORMER"].name]
              }],

            },
            {
              names   = ["GPS"]
              columns = jsondecode(file("${path.module}/modules/database/columns/streaming/GPS.json"))

              grants = [{
                privileges = ["SELECT"]
                roles      = [module.core[0].roles["TRANSFORMER"].name]
              }]
            }
          ]

          tasks = [
            {
              name = "LOAD_GPS_MERGE_TASK"

              schedule      = "1 MINUTE"
              sql_statement = file("${path.module}/modules/database/merge_commands/streaming/LOAD_GPS.sql")

              user_task_managed_initial_warehouse_size = "XSMALL"
              when                                     = "SYSTEM$STREAM_HAS_DATA('LOAD_GPS_STREAM')"

              enabled = true
            }
          ]

          grants = [{
            privilege = "USAGE"
            roles     = [module.core[0].roles["TRANSFORMER"].name]
          }]
        },

        {
          name = "SP"

          stages = [{
            name                = "SP_STAGE"
            url                 = "${var.storage_account_url}/sharepoint"
            storage_integration = module.integration[0].storage_integration["AZ_STORAGE_INTEGRATION"].name
            file_format         = "TYPE = PARQUET NULL_IF = []"
          }]

          file_formats = []

          procedures = [
            {
              name     = "LOAD_AUXCARRIERFAILURELOG_MERGE_PROC"
              language = "SQL"

              arguments = []

              return_type = "VARIANT"

              statement = file("${path.module}/modules/database/procedures/sp/LOAD_AUXCARRIERFAILURELOG.sql")
            },
            {
              name     = "LOAD_AUXFAILUREREASONCODES_MERGE_PROC"
              language = "SQL"

              arguments = []

              return_type = "VARIANT"

              statement = file("${path.module}/modules/database/procedures/sp/LOAD_AUXFAILUREREASONCODES.sql")
            },
            {
              name     = "LOAD_CFXCOSTCENTRES_MERGE_PROC"
              language = "SQL"

              arguments = []

              return_type = "VARIANT"

              statement = file("${path.module}/modules/database/procedures/sp/LOAD_CFXCOSTCENTRES.sql")
            },
            {
              name     = "LOAD_DCMCOMPLIANCEAUDITMONITOR_MERGE_PROC"
              language = "SQL"

              arguments = []

              return_type = "VARIANT"

              statement = file("${path.module}/modules/database/procedures/sp/LOAD_DCMCOMPLIANCEAUDITMONITOR.sql")
            },
            {
              name     = "LOAD_FRTCUSTOMERLIST_MERGE_PROC"
              language = "SQL"

              arguments = []

              return_type = "VARIANT"

              statement = file("${path.module}/modules/database/procedures/sp/LOAD_FRTCUSTOMERLIST.sql")
            },
            {
              name     = "LOAD_FUELPRICES_MERGE_PROC"
              language = "SQL"

              arguments = []

              return_type = "VARIANT"

              statement = file("${path.module}/modules/database/procedures/sp/LOAD_FUELPRICES.sql")
            },
            {
              name     = "LOAD_USERINFORMATIONLIST_MERGE_PROC"
              language = "SQL"

              arguments = []

              return_type = "VARIANT"

              statement = file("${path.module}/modules/database/procedures/sp/LOAD_USERINFORMATIONLIST.sql")
            }
          ]

          tables = [
            {
              names = ["LOAD_AUXCARRIERFAILURELOG", "LOAD_AUXFAILUREREASONCODES", "LOAD_DCMCOMPLIANCEAUDITMONITOR", "LOAD_FUELPRICES", "LOAD_CFXCOSTCENTRES", "LOAD_FRTCUSTOMERLIST", "LOAD_USERINFORMATIONLIST"]

              columns = [{
                name = "VAR"
                type = "VARIANT"
              }]

              pipes = {
                file_names = ["AUXCarrierFailureLog", "AUXFailureReasonCodes", "DCMComplianceAuditMonitor", "FuelPrices", "CFXCostCentres", "FRTCustomerList", "UserInformationList"]

                auto_ingest = true
                integration = "AZ_STORAGE_QUEUE_INTEGRATION"
                stage_name  = "SP_STAGE"
              }

              streams          = true
              tasks_on_streams = true
              change_tracking  = true

              grants = [{
                privileges = ["SELECT"]
                roles      = [module.core[0].roles["TRANSFORMER"].name]
              }]
            },
            {
              names   = ["AUXCARRIERFAILURELOG"]
              columns = jsondecode(file("${path.module}/modules/database/columns/sp/AUXCARRIERFAILURELOG.json"))

              grants = [{
                privileges = ["SELECT"]
                roles      = [module.core[0].roles["TRANSFORMER"].name]
              }]
            },
            {
              names   = ["AUXFAILUREREASONCODES"]
              columns = jsondecode(file("${path.module}/modules/database/columns/sp/AUXFAILUREREASONCODES.json"))

              grants = [{
                privileges = ["SELECT"]
                roles      = [module.core[0].roles["TRANSFORMER"].name]
              }]
            },
            {
              names   = ["DCMCOMPLIANCEAUDITMONITOR"]
              columns = jsondecode(file("${path.module}/modules/database/columns/sp/DCMCOMPLIANCEAUDITMONITOR.json"))

              grants = [{
                privileges = ["SELECT"]
                roles      = [module.core[0].roles["TRANSFORMER"].name]
              }]
            },
            {
              names   = ["FUELPRICES"]
              columns = jsondecode(file("${path.module}/modules/database/columns/sp/FUELPRICES.json"))

              grants = [{
                privileges = ["SELECT"]
                roles      = [module.core[0].roles["TRANSFORMER"].name]
              }]
            },
            {
              names   = ["CFXCOSTCENTRES"]
              columns = jsondecode(file("${path.module}/modules/database/columns/sp/CFXCOSTCENTRES.json"))
              pipes   = null

              grants = [{
                privileges = ["SELECT"]
                roles      = [module.core[0].roles["TRANSFORMER"].name]
              }]
            },
            {
              names   = ["FRTCUSTOMERLIST"]
              columns = jsondecode(file("${path.module}/modules/database/columns/sp/FRTCUSTOMERLIST.json"))
              pipes   = null

              grants = [{
                privileges = ["SELECT"]
                roles      = [module.core[0].roles["TRANSFORMER"].name]
              }]
            },
            {
              names   = ["USERINFORMATIONLIST"]
              columns = jsondecode(file("${path.module}/modules/database/columns/sp/USERINFORMATIONLIST.json"))
              pipes   = null

              grants = [{
                privileges = ["SELECT"]
                roles      = [module.core[0].roles["TRANSFORMER"].name]
              }]
            }
          ]

          grants = [{
            privilege = "USAGE"
            roles     = [module.core[0].roles["TRANSFORMER"].name]
          }]
        },
        {
          name = "GA"

          stages = [{
            name                = "GA_STAGE"
            url                 = "${var.storage_account_url}/google-analytics"
            storage_integration = module.integration[0].storage_integration["AZ_STORAGE_INTEGRATION"].name
            file_format         = "TYPE = PARQUET NULL_IF = []"
          }]

          functions = [{
            name     = "parse_ga4_object_array_func"
            language = "javascript"

            arguments = [{
              name = "V"
              type = "VARIANT"
            }]

            return_type = "VARIANT"

            statement = <<EOT
            const result = {}
            if(V) {
              V.map((x) => {
                if(x.key === "profile_ID") {              
                  result[x.key] = Object.keys(x.value).some(
                    (key) => key === "set_timestamp_micros"
                  )
                    ? x.value
                    : {"set_timestamp_micros" : null, "string_value": Object.values(x.value)[0]};
                } else {
                    result[x.key] = Object.keys(x.value).some(
                    (key) => key === "set_timestamp_micros"
                  )
                    ? x.value
                    : Object.values(x.value)[0];
                }
              });
            }
            return result;
            EOT
          }]

          procedures = [
            {
              name     = "LOAD_ANALYTICS_287952780_MERGE_PROC"
              language = "SQL"

              arguments = []

              return_type = "VARIANT"

              statement = file("${path.module}/modules/database/procedures/ga/LOAD_ANALYTICS_287952780.sql")
            },
            {
              name     = "LOAD_ANALYTICS_288010047_MERGE_PROC"
              language = "SQL"

              arguments = []

              return_type = "VARIANT"

              statement = file("${path.module}/modules/database/procedures/ga/LOAD_ANALYTICS_288010047.sql")
            }
          ]

          tables = [
            {
              names = ["LOAD_ANALYTICS_288010047", "LOAD_ANALYTICS_287952780"]
              columns = [{
                name = "VAR"
                type = "VARIANT"
              }]

              pipes = {
                file_names = ["analytics_288010047", "analytics_287952780"]

                auto_ingest = true
                integration = "AZ_STORAGE_QUEUE_INTEGRATION"
                stage_name  = "GA_STAGE"
              }

              streams          = true
              tasks_on_streams = true
              change_tracking  = true

              grants = [{
                privileges = ["SELECT"]
                roles      = [module.core[0].roles["TRANSFORMER"].name]
              }]
            },
            {
              names   = ["ANALYTICS_288010047"]
              columns = jsondecode(file("${path.module}/modules/database/columns/ga/ANALYTICS_288010047.json"))

              grants = [{
                privileges = ["SELECT"]
                roles      = [module.core[0].roles["TRANSFORMER"].name]
              }]
            },
            {
              names   = ["ANALYTICS_287952780"]
              columns = jsondecode(file("${path.module}/modules/database/columns/ga/ANALYTICS_287952780.json"))

              grants = [{
                privileges = ["SELECT"]
                roles      = [module.core[0].roles["TRANSFORMER"].name]
              }]
            },
          ]

          grants = [{
            privilege = "USAGE"
            roles     = [module.core[0].roles["TRANSFORMER"].name]
          }]
        },
        {
          name = "METADATA"

          grants = [{
            privilege = "USAGE"
            roles     = [module.core[0].roles["TRANSFORMER"].name]
            }, {
            privilege = "CREATE VIEW"
            roles     = ["ACCOUNTADMIN"]
          }]

          external_functions = [{
            name = "SEND_ERROR"

            arguments = [{
              name = "message"
              type = "VARIANT"
            }]

            return_type     = "variant"
            return_behavior = "VOLATILE"

            api_integration           = module.integration[0].api_integration.name
            url_of_proxy_and_resource = "${var.api_management_url}errors"
          }]

          tables = [
            {
              names = ["DATA_REFRESHES"]
              columns = [
                { name = "ROOT_TASK_NAME", type = "VARCHAR(16777216)" },
                { name = "TABLE_NAME", type = "VARCHAR(16777216)" },
                { name = "DATABASE_NAME", type = "VARCHAR(16777216)" },
                { name = "SCHEMA_NAME", type = "VARCHAR(16777216)" },
                { name = "LAST_UPDATED_TIME", type = "TIMESTAMP_NTZ(9)" },
                { name = "RUN_ID", type = "NUMBER(38,0)" },
              ]

              grants = [{
                privileges = ["SELECT"]
                roles      = [module.core[0].roles["TRANSFORMER"].name]
              }]
            },
            {
              names   = ["COPY_RECORD"]
              columns = jsondecode(file("${path.module}/modules/database/columns/metadata/COPY_RECORD.json"))

              grants = [{
                privileges = ["SELECT"]
                roles      = [module.core[0].roles["TRANSFORMER"].name]
              }]
            },
            {
              names   = ["FRESHNESS"]
              columns = jsondecode(file("${path.module}/modules/database/columns/metadata/FRESHNESS.json"))

              grants = [{
                privileges = ["SELECT"]
                roles      = [module.core[0].roles["TRANSFORMER"].name]
              }]
            },
            {
              names   = ["TASK_RECORD"]
              columns = jsondecode(file("${path.module}/modules/database/columns/metadata/TASK_RECORD.json"))

              grants = [{
                privileges = ["SELECT"]
                roles      = [module.core[0].roles["TRANSFORMER"].name]
              }]
            },
            {
              names = ["COLUMN_DRIFT_STATUS"]
              columns = [
                { name = "TABLE_NAME", type = "VARCHAR(16777216)" },
                { name = "STATUS", type = "VARCHAR(16777216)" },
                { name = "ERROR_INFO", type = "VARCHAR(16777216)" },
                { name = "FILE_INFO", type = "VARCHAR(16777216)" },
              ]

              grants = [{
                privileges = ["SELECT"]
                roles      = [module.core[0].roles["TRANSFORMER"].name]
              }]
            }
          ]

          admin_views = [{
            name = "COPY_HISTORY"

            statement = <<-SQL
          SELECT * FROM SNOWFLAKE.ACCOUNT_USAGE.COPY_HISTORY;
            SQL

            grants = [{
              privilege = "SELECT"
              roles     = [module.core[0].roles["LOADER"].name]
            }]
          }]

          tasks = [
            {
              name = "DATA_REFRESHES_UPDATE_TASK"

              schedule      = "5 MINUTES"
              sql_statement = file("${path.module}/modules/database/merge_commands/metadata/DATA_REFRESHES.sql")

              user_task_managed_initial_warehouse_size = "XSMALL"

              enabled = true
            },
            {
              name = "COPY_RECORDS_RETRIEVAL"

              schedule      = "USING CRON 0 4 * * * UTC"
              sql_statement = file("${path.module}/modules/database/merge_commands/metadata/COPY_RECORDS_RETRIEVAL.sql")

              user_task_managed_initial_warehouse_size = "XSMALL"

              enabled = true
            },
            {
              name = "TASK_RECORDS_RETRIEVAL"

              schedule      = "USING CRON 0 4 * * * UTC"
              sql_statement = file("${path.module}/modules/database/merge_commands/metadata/TASK_RECORDS_RETRIEVAL.sql")

              user_task_managed_initial_warehouse_size = "XSMALL"

              enabled = true
            },
            {
              name = "DRIFT_CHECK_TASK"

              schedule      = "USING CRON 30 1 * * THU UTC"
              sql_statement = "CALL RAW.METADATA.COLUMN_DRIFT()"

              warehouse = "COMPUTE_WH"

              enabled = true
            }
          ]
        },
        {
          name = "AIRTABLE"

          stages = [{
            name                = "AIRTABLE_STAGE"
            url                 = "${var.storage_account_url}/airtable"
            storage_integration = module.integration[0].storage_integration["AZ_STORAGE_INTEGRATION"].name
            file_format         = "TYPE = PARQUET NULL_IF = []"
          }]

          procedures = [
            {
              name     = "LOAD_ASH_ACTUAL_MERGE_PROC"
              language = "SQL"

              arguments = []

              return_type = "VARIANT"

              statement = file("${path.module}/modules/database/procedures/airtable/LOAD_ASH_ACTUAL.sql")
            },
            {
              name     = "LOAD_WEEKLY_TARGETS_MERGE_PROC"
              language = "SQL"

              arguments = []

              return_type = "VARIANT"

              statement = file("${path.module}/modules/database/procedures/airtable/LOAD_WEEKLY_TARGETS.sql")
            },
            {
              name     = "LOAD_HANDBACK_LOG_MERGE_PROC"
              language = "SQL"

              arguments = []

              return_type = "VARIANT"

              statement = file("${path.module}/modules/database/procedures/airtable/LOAD_HANDBACK_LOG.sql")
            },
            {
              name     = "LOAD_CARRIERS_VEHICLES_MERGE_PROC"
              language = "SQL"

              arguments = []

              return_type = "VARIANT"

              statement = file("${path.module}/modules/database/procedures/airtable/LOAD_CARRIERS_VEHICLES.sql")
            },
            {
              name     = "LOAD_VEHICLE_BANDING_MERGE_PROC"
              language = "SQL"

              arguments = []

              return_type = "VARIANT"

              statement = file("${path.module}/modules/database/procedures/airtable/LOAD_VEHICLE_BANDING.sql")
            }
          ]

          tables = [
            {
              names = ["LOAD_CARRIER", "LOAD_WEEKLY_TARGETS", "LOAD_ASH_ACTUAL", "LOAD_HANDBACK_LOG", "LOAD_SHIPPER_INFORMATION", "LOAD_CARRIERS_VEHICLES", "LOAD_VEHICLE_BANDING"]
              columns = [{
                name = "VAR"
                type = "VARIANT"
              }]

              pipes = {
                file_names  = ["CARRIER", "WEEKLY_TARGETS", "ASH_ACTUAL", "HANDBACK_LOG", "SHIPPER_INFORMATION", "CARRIERS_VEHICLES", "VEHICLE_BANDING"]
                auto_ingest = true
                integration = "AZ_STORAGE_QUEUE_INTEGRATION"
                stage_name  = "AIRTABLE_STAGE"
              }

              streams          = true
              tasks_on_streams = true
              change_tracking  = true

              grants = [{
                privileges = ["SELECT"]
                roles      = [module.core[0].roles["TRANSFORMER"].name]
              }],

            },
            {
              names   = ["CARRIER"]
              columns = jsondecode(file("${path.module}/modules/database/columns/airtable/CARRIER.json"))

              grants = [{
                privileges = ["SELECT"]
                roles      = [module.core[0].roles["TRANSFORMER"].name]
              }]
            },
            {
              names   = ["WEEKLY_TARGETS"]
              columns = jsondecode(file("${path.module}/modules/database/columns/airtable/WEEKLY_TARGETS.json"))

              grants = [{
                privileges = ["SELECT"]
                roles      = [module.core[0].roles["TRANSFORMER"].name]
              }]
            },
            {
              names   = ["ASH_ACTUAL"]
              columns = jsondecode(file("${path.module}/modules/database/columns/airtable/ASH_ACTUAL.json"))

              grants = [{
                privileges = ["SELECT"]
                roles      = [module.core[0].roles["TRANSFORMER"].name]
              }]
            },
            {
              names   = ["HANDBACK_LOG"]
              columns = jsondecode(file("${path.module}/modules/database/columns/airtable/HANDBACK_LOG.json"))

              grants = [{
                privileges = ["SELECT"]
                roles      = [module.core[0].roles["TRANSFORMER"].name]
              }]
            },
            {
              names   = ["SHIPPER_INFORMATION"]
              columns = jsondecode(file("${path.module}/modules/database/columns/airtable/SHIPPER_INFORMATION.json"))

              grants = [{
                privileges = ["SELECT"]
                roles      = [module.core[0].roles["TRANSFORMER"].name]
              }]
            },
            {
              names   = ["CARRIERS_VEHICLES"]
              columns = jsondecode(file("${path.module}/modules/database/columns/airtable/CARRIERS_VEHICLES.json"))

              grants = [{
                privileges = ["SELECT"]
                roles      = [module.core[0].roles["TRANSFORMER"].name]
              }]
            },
            {
              names   = ["VEHICLE_BANDING"]
              columns = jsondecode(file("${path.module}/modules/database/columns/airtable/VEHICLE_BANDING.json"))

              grants = [{
                privileges = ["SELECT"]
                roles      = [module.core[0].roles["TRANSFORMER"].name]
              }]
            }
          ]

          grants = [{
            privilege = "USAGE"
            roles     = [module.core[0].roles["TRANSFORMER"].name]
          }]
        },
        {
          name = "AIRTABLE_UK"
          grants = [{
            privilege = "USAGE"
            roles = flatten([
              module.core[0].roles["TRANSFORMER"].name,
              module.core[0].roles["ANALYST"].name,
              module.core[0].roles["UK_ANALYST"].name,
              var.environment != "PROD" ? [module.core[0].roles["DEVELOPER"].name] : []
            ])
          }]

          stages = [{
            name                = "BACKHAUL_AIRTABLE_STAGE"
            url                 = "${var.storage_account_url}/backhaul-airtable"
            storage_integration = module.integration[0].storage_integration["AZ_STORAGE_INTEGRATION"].name
          }]
        },
        {
          name = "AIRTABLE_MX"
          grants = [{
            privilege = "USAGE"
            roles = flatten([
              module.core[0].roles["TRANSFORMER"].name,
              module.core[0].roles["ANALYST"].name,
              module.core[0].roles["MX_ANALYST"].name,
              module.core[0].roles["MX_TRANSFORMER"].name,
              var.environment != "PROD" ? [module.core[0].roles["DEVELOPER"].name] : []
            ])
          }]
        },
        {
          name = "TARGET_BUY_RATES"

          stages = [{
            name                = "TARGET_BUY_RATES_STAGE"
            url                 = "${var.storage_account_url}/target-buy-rates"
            storage_integration = module.integration[0].storage_integration["AZ_STORAGE_INTEGRATION"].name
            file_format_name    = "CSV_TARGET_BUY_RATES_FILE_FORMAT"
          }]
          file_formats = [{
            name                           = "CSV_TARGET_BUY_RATES_FILE_FORMAT"
            format_type                    = "CSV"
            record_delimiter               = "\n"
            field_delimiter                = ","
            date_format                    = "AUTO"
            time_format                    = "AUTO"
            binary_format                  = "HEX"
            escape                         = "NONE"
            escape_unenclosed_field        = "\\"
            field_optionally_enclosed_by   = "\""
            empty_field_as_null            = true
            timestamp_format               = "MM/DD/YYYY HH24:MI"
            error_on_column_count_mismatch = false
            encoding                       = "UTF8"
            compression                    = "AUTO"
            skip_header                    = true

            grants = []
          }]

          procedures = [
            {
              name     = "LOAD_TARGET_BUY_RATE_PROJECTS_MERGE_PROC"
              language = "SQL"

              arguments = []

              return_type = "VARIANT"

              statement = file("${path.module}/modules/database/procedures/target_buy_rates/LOAD_TARGET_BUY_RATE_PROJECTS.sql")
            },

            {
              name     = "LOAD_TARGET_BUY_RATE_MERGE_PROC"
              language = "SQL"

              arguments = []

              return_type = "VARIANT"

              statement = file("${path.module}/modules/database/procedures/target_buy_rates/LOAD_TARGET_BUY_RATE.sql")
            }
          ]

          tables = [
            {
              names = ["LOAD_TARGET_BUY_RATE"]

              columns = jsondecode(file("${path.module}/modules/database/columns/target_buy_rates/LOAD_TARGET_BUY_RATE.json"))

              pipes = {
                file_names = ["TargetBuyRate"]

                auto_ingest = true
                integration = "AZ_STORAGE_QUEUE_INTEGRATION"
                stage_name  = "TARGET_BUY_RATES_STAGE"
              }

              streams          = true
              change_tracking  = true
              tasks_on_streams = true

              grants = [{
                privileges = ["SELECT"]
                roles      = [module.core[0].roles["TRANSFORMER"].name]
              }]
            },
            {
              names = ["TARGET_BUY_RATE"]

              columns = jsondecode(file("${path.module}/modules/database/columns/target_buy_rates/TARGET_BUY_RATE.json"))

              grants = [{
                privileges = ["SELECT"]
                roles      = [module.core[0].roles["TRANSFORMER"].name]
              }]
            },
            {
              names = ["LOAD_TARGET_BUY_RATE_PROJECTS"]

              columns = jsondecode(file("${path.module}/modules/database/columns/target_buy_rates/LOAD_TARGET_BUY_RATE_PROJECTS.json"))

              pipes = {
                file_names = ["TargetBuyRateProjects"]

                auto_ingest = true
                integration = "AZ_STORAGE_QUEUE_INTEGRATION"
                stage_name  = "TARGET_BUY_RATES_STAGE"
              }

              streams          = true
              change_tracking  = true
              tasks_on_streams = true

              grants = [{
                privileges = ["SELECT"]
                roles      = [module.core[0].roles["TRANSFORMER"].name]
              }]
            },
            {
              names = ["TARGET_BUY_RATE_PROJECTS"]

              columns = jsondecode(file("${path.module}/modules/database/columns/target_buy_rates/TARGET_BUY_RATE_PROJECTS.json"))

              grants = [{
                privileges = ["SELECT"]
                roles      = [module.core[0].roles["TRANSFORMER"].name]
              }]
            }
          ]

          grants = [{
            privilege = "USAGE"
            roles     = [module.core[0].roles["TRANSFORMER"].name]
          }]
        },
        {
          name = "HISTORICAL_BUY_RATES"

          stages = [{
            name                = "HISTORICAL_BUY_RATES_STAGE"
            url                 = "${var.storage_account_url}/historical-buy-rates"
            storage_integration = module.integration[0].storage_integration["AZ_STORAGE_INTEGRATION"].name
            file_format_name    = "CSV_HISTORICAL_BUY_RATES_FILE_FORMAT"
          }]
          file_formats = [{
            name                           = "CSV_HISTORICAL_BUY_RATES_FILE_FORMAT"
            format_type                    = "CSV"
            record_delimiter               = "\n"
            field_delimiter                = ","
            date_format                    = "AUTO"
            time_format                    = "AUTO"
            binary_format                  = "HEX"
            escape                         = "NONE"
            escape_unenclosed_field        = "\\"
            field_optionally_enclosed_by   = "\""
            empty_field_as_null            = true
            timestamp_format               = "MM/DD/YYYY HH24:MI"
            error_on_column_count_mismatch = false
            encoding                       = "UTF8"
            compression                    = "AUTO"
            skip_header                    = true

            grants = []
          }]

          tables = [
            {
              names = ["LOAD_HISTORICAL_BUY_RATES"]

              columns = jsondecode(file("${path.module}/modules/database/columns/historical_buy_rates/LOAD_HISTORICAL_BUY_RATES.json"))

              pipes = {
                file_names = ["HistoricalBuyRate"]

                auto_ingest = true
                integration = "AZ_STORAGE_QUEUE_INTEGRATION"
                stage_name  = "HISTORICAL_BUY_RATES_STAGE"
              }

              streams          = true
              change_tracking  = true
              tasks_on_streams = true

              grants = [{
                privileges = ["SELECT"]
                roles      = [module.core[0].roles["TRANSFORMER"].name]
              }]
            },
            {
              names = ["HISTORICAL_BUY_RATES"]

              columns = jsondecode(file("${path.module}/modules/database/columns/historical_buy_rates/HISTORICAL_BUY_RATES.json"))

              grants = [{
                privileges = ["SELECT"]
                roles      = [module.core[0].roles["TRANSFORMER"].name]
              }]
            }
          ]

          grants = [{
            privilege = "USAGE"
            roles     = [module.core[0].roles["TRANSFORMER"].name]
          }]
        },
        {
          name = "BACKHAUL_MATCHING"

          stages = [{
            name                = "BACKHAUL_MATCHING_STAGE"
            url                 = "${var.storage_account_url}/backhaul-matching"
            storage_integration = module.integration[0].storage_integration["AZ_STORAGE_INTEGRATION"].name
            file_format_name    = "CSV_BACKHAUL_MATCHING_FORMAT"
          }]

          file_formats = [{
            name                           = "CSV_BACKHAUL_MATCHING_FORMAT"
            format_type                    = "CSV"
            record_delimiter               = "\n"
            field_delimiter                = ","
            field_optionally_enclosed_by   = "\""
            date_format                    = "AUTO"
            time_format                    = "AUTO"
            binary_format                  = "HEX"
            escape                         = "NONE"
            escape_unenclosed_field        = "\\"
            empty_field_as_null            = true
            error_on_column_count_mismatch = true
            encoding                       = "UTF8"
            compression                    = "AUTO"
            skip_header                    = true

            grants = []
          }]

          tables = [
            {
              names   = ["LOAD_BACKHAUL_MATCHING_DAILY_RESULTS"]
              columns = jsondecode(file("${path.module}/modules/database/columns/backhaul_matching/LOAD_BACKHAUL_MATCHING_DAILY_RESULTS.json"))


              pipes = {
                file_names  = ["backhaul_matching_daily_results"]
                auto_ingest = true
                integration = "AZ_STORAGE_QUEUE_INTEGRATION"
                stage_name  = "BACKHAUL_MATCHING_STAGE"
              }

              streams          = true
              tasks_on_streams = true
              change_tracking  = true
            },
            {
              names = ["BACKHAUL_MATCHING_DAILY_RESULTS"]

              columns = jsondecode(file("${path.module}/modules/database/columns/backhaul_matching/BACKHAUL_MATCHING_DAILY_RESULTS.json"))

              grants = [{
                privileges = ["INSERT"]
                roles      = [module.core[0].roles["LOADER"].name]
                },
                {
                  privileges = ["SELECT"]
                  roles = flatten([
                    module.core[0].roles["LOADER"].name,
                    module.core[0].roles["TRANSFORMER"].name,
                    var.environment != "PROD" ? [module.core[0].roles["DEVELOPER"].name] : []
                  ])
                }
              ]
          }]

          grants = [{
            privilege = "USAGE"
            roles = flatten([
              module.core[0].roles["TRANSFORMER"].name,
              var.environment != "PROD" ? [module.core[0].roles["DEVELOPER"].name] : [],
              module.core[0].roles["REPORTER"].name,
              module.core[0].roles["LOADER"].name
            ])
          }]

        },
        {
          name = "PHA_FORECAST"

          stages = [{
            name                = "PHA_FORECAST_STAGE"
            url                 = "${var.storage_account_url}/pha-forecast"
            storage_integration = module.integration[0].storage_integration["AZ_STORAGE_INTEGRATION"].name
            file_format_name    = "PHA_FORECAST_FILE_FORMAT"
          }]
          file_formats = [{
            name                           = "PHA_FORECAST_FILE_FORMAT"
            format_type                    = "CSV"
            record_delimiter               = "\n"
            field_delimiter                = ","
            date_format                    = "AUTO"
            time_format                    = "AUTO"
            binary_format                  = "HEX"
            escape                         = "NONE"
            escape_unenclosed_field        = "\\"
            field_optionally_enclosed_by   = "\""
            empty_field_as_null            = true
            error_on_column_count_mismatch = false
            encoding                       = "UTF8"
            compression                    = "AUTO"
            skip_header                    = true

            grants = []
          }]

          tables = [
            {
              names = ["LOAD_PHA_FORECAST"]

              columns = jsondecode(file("${path.module}/modules/database/columns/pha_forecast/LOAD_PHA_FORECAST.json"))

              pipes = {
                file_names = ["pha_forecast"]

                auto_ingest = true
                integration = "AZ_STORAGE_QUEUE_INTEGRATION"
                stage_name  = "PHA_FORECAST_STAGE"
              }

              streams          = true
              change_tracking  = true
              tasks_on_streams = true

              grants = [{
                privileges = ["SELECT"]
                roles      = [module.core[0].roles["TRANSFORMER"].name]
              }]
            },
            {
              names = ["PHA_FORECAST"]

              columns = jsondecode(file("${path.module}/modules/database/columns/pha_forecast/PHA_FORECAST.json"))

              grants = [{
                privileges = ["SELECT"]
                roles      = [module.core[0].roles["TRANSFORMER"].name]
              }]
            }
          ]

          grants = [{
            privilege = "USAGE"
            roles     = [module.core[0].roles["TRANSFORMER"].name]
          }]
        },
        {
          name = "CARBON_REPORT"

          stages = [{
            name                = "CARBON_REPORT_STAGE"
            url                 = "${var.storage_account_url}/carbon-reporting"
            storage_integration = module.integration[0].storage_integration["AZ_STORAGE_INTEGRATION"].name
            file_format_name    = "CARBON_REPORT_FILE_FORMAT"
          }]
          file_formats = [{
            name                           = "CARBON_REPORT_FILE_FORMAT"
            format_type                    = "CSV"
            record_delimiter               = "\n"
            field_delimiter                = ","
            date_format                    = "AUTO"
            time_format                    = "AUTO"
            binary_format                  = "HEX"
            escape                         = "NONE"
            escape_unenclosed_field        = "\\"
            field_optionally_enclosed_by   = "\""
            empty_field_as_null            = true
            error_on_column_count_mismatch = false
            encoding                       = "UTF8"
            compression                    = "AUTO"
            skip_header                    = true

            grants = []
          }]

          tables = [
            {
              names = ["LOAD_CARBON_REPORT"]

              columns = jsondecode(file("${path.module}/modules/database/columns/carbon_report/LOAD_CARBON_REPORT.json"))

              pipes = {
                file_names = ["carbon_report"]

                auto_ingest = true
                integration = "AZ_STORAGE_QUEUE_INTEGRATION"
                stage_name  = "CARBON_REPORT_STAGE"
              }

              streams          = true
              change_tracking  = true
              tasks_on_streams = true

              grants = [{
                privileges = ["SELECT"]
                roles      = [module.core[0].roles["TRANSFORMER"].name]
              }]
            },
            {
              names = ["CARBON_REPORT"]

              columns = jsondecode(file("${path.module}/modules/database/columns/carbon_report/CARBON_REPORT.json"))

              grants = [{
                privileges = ["SELECT"]
                roles      = [module.core[0].roles["TRANSFORMER"].name]
              }]
            }
          ]

          grants = [{
            privilege = "USAGE"
            roles     = [module.core[0].roles["TRANSFORMER"].name]
          }]
        }
      ])

      grants = [{
        privilege = "USAGE"
        roles = flatten([
          module.core[0].roles["TRANSFORMER"].name,
          module.core[0].roles["ANALYST"].name,
          module.core[0].roles["MX_ANALYST"].name,
          module.core[0].roles["UK_ANALYST"].name,
          module.core[0].roles["MX_TRANSFORMER"].name,
          var.environment != "PROD" ? [module.core[0].roles["DEVELOPER"].name] : []
        ])
      }]
    },
    {
      name               = "ANALYTICS"
      transfer_ownership = module.core[0].roles["TRANSFORMER"].name

      schemas = [
        {
          name = "RAG_SCORING_LIVE_OFFER"

          tables = [{
            names = ["CARRIER_RAG_KPI_HISTORY"]

            columns = jsondecode(file("${path.module}/modules/database/columns/rag_scoring_live_offer/CARRIER_RAG_KPI_HISTORY.json"))

            grants = [{
              privileges = ["INSERT"]
              roles      = [module.core[0].roles["LOADER"].name]
              },
              {
                privileges = ["SELECT"]
                roles = flatten([
                  module.core[0].roles["LOADER"].name,
                  module.core[0].roles["TRANSFORMER"].name,
                  var.environment != "PROD" ? [module.core[0].roles["DEVELOPER"].name] : []
                ])
              }
            ]
          }]

          grants = [{
            privilege = "USAGE"
            roles = flatten([
              module.core[0].roles["TRANSFORMER"].name,
              var.environment != "PROD" ? [module.core[0].roles["DEVELOPER"].name] : [],
              module.core[0].roles["RAG_SCORING"].name,
              module.core[0].roles["REPORTER"].name,
              module.core[0].roles["LOADER"].name
            ])
          }]

          stages = [{
            name                = "RAG_SCORING_EXPORT_STAGE"
            url                 = "${var.storage_account_url}/rag-kpi-export"
            storage_integration = module.integration[0].storage_integration["AZ_STORAGE_INTEGRATION"].name
          }]
        },
        {
          name = "STREAMLIT"

          grants = [{
            privilege = "USAGE"
            roles     = [module.core[0].roles["ANALYST"].name]
            }, {
            privilege = "CREATE STREAMLIT"
            roles     = [module.core[0].roles["ANALYST"].name]
            }, {
            privilege = "CREATE table"
            roles     = [module.core[0].roles["ANALYST"].name]
            }, {
            privilege = "CREATE STAGE"
            roles     = [module.core[0].roles["ANALYST"].name]
          }]

        }

      ]


      grants = [{
        privilege = "USAGE"
        roles = flatten([
          module.core[0].roles["TRANSFORMER"].name,
          module.core[0].roles["REPORTER"].name,
          module.core[0].roles["ANALYST"].name,
          module.core[0].roles["RAG_SCORING"].name,
          module.core[0].roles["LOADER"].name,
          module.core[0].roles["MX_ANALYST"].name,
          module.core[0].roles["UK_ANALYST"].name,
          module.core[0].roles["UK_REPORTER"].name,
          var.environment != "PROD" ? [module.core[0].roles["DEVELOPER"].name] : []
        ])
      }]
    },
    var.environment != "PROD" ? [
      {
        name               = "${var.environment_prefix}ANALYTICS"
        transfer_ownership = module.core[0].roles["TRANSFORMER"].name
        dev_only           = true
        grants = [
          {
            privilege = "USAGE"
            roles = flatten([
              module.core[0].roles["TRANSFORMER"].name,
              module.core[0].roles["ANALYST"].name,
              module.core[0].roles["UK_ANALYST"].name,
              module.core[0].roles["LOADER"].name,
              var.environment != "PROD" ? [module.core[0].roles["DEVELOPER"].name] : []
            ])
          },
          {
            privilege = "CREATE SCHEMA"
            roles = flatten([
              module.core[0].roles["UK_ANALYST"].name,
              module.core[0].roles["ANALYST"].name,
              var.environment != "PROD" ? [module.core[0].roles["DEVELOPER"].name] : []
            ])
          }
        ]
    }] : [],
    var.environment != "PROD" ? [
      {
        name               = "DEV_MX_ANALYTICS"
        transfer_ownership = module.core[0].roles["TRANSFORMER"].name
        grants = [
          {
            privilege = "USAGE"
            roles = flatten([
              module.core[0].roles["MX_ANALYST"].name,
              module.core[0].roles["ANALYST"].name
            ])
          },
          {
            privilege = "CREATE SCHEMA"
            roles = flatten([
              module.core[0].roles["MX_ANALYST"].name,
              module.core[0].roles["ANALYST"].name
            ])
          }
        ]
    }] : [],
    {
      name               = "CORE"
      transfer_ownership = module.core[0].roles["TRANSFORMER"].name

      grants = [{
        privilege = "USAGE"
        roles = flatten([
          module.core[0].roles["TRANSFORMER"].name,
          module.core[0].roles["REPORTER"].name,
          module.core[0].roles["ANALYST"].name,
          module.core[0].roles["UK_ANALYST"].name,
          module.core[0].roles["MX_ANALYST"].name,
          module.core[0].roles["MX_TRANSFORMER"].name,
          var.environment != "PROD" ? [module.core[0].roles["DEVELOPER"].name] : []
        ])
      }]
    },
    var.environment != "PROD" ? [{
      name               = "${var.environment_prefix}CORE"
      transfer_ownership = module.core[0].roles["TRANSFORMER"].name
      dev_only           = true
      grants = [{
        privilege = "USAGE"
        roles = flatten([
          module.core[0].roles["TRANSFORMER"].name,
          module.core[0].roles["ANALYST"].name,
          module.core[0].roles["LOADER"].name,
          var.environment != "PROD" ? [module.core[0].roles["DEVELOPER"].name] : []
        ])
      }]
    }] : [],
    {
      name               = "MX_ANALYTICS"
      transfer_ownership = module.core[0].roles["TRANSFORMER"].name

      schemas = [{
        name = "STREAMLIT"

        grants = [{
          privilege = "USAGE"
          roles     = [module.core[0].roles["MX_ANALYST"].name]
          }, {
          privilege = "CREATE STREAMLIT"
          roles     = [module.core[0].roles["MX_ANALYST"].name]
          }, {
          privilege = "CREATE STAGE"
          roles     = [module.core[0].roles["MX_ANALYST"].name]
        }]
      }]

      grants = [
        {
          privilege = "USAGE"
          roles = flatten([
            module.core[0].roles["MX_ANALYST"].name,
            module.core[0].roles["MX_TRANSFORMER"].name,
            module.core[0].roles["ANALYST"].name,
            module.core[0].roles["REPORTER"].name,
            module.core[0].roles["MX_REPORTER"].name
          ])
        },
        {
          privilege = "CREATE SCHEMA"
          roles = flatten([
            module.core[0].roles["MX_TRANSFORMER"].name,
            module.core[0].roles["ANALYST"].name,
          ])
        }
      ]
    }

  ])
  developer_role = var.environment != "PROD" && lookup(module.core[0].roles, "DEVELOPER", null) != null ? module.core[0].roles["DEVELOPER"].name : null
}
