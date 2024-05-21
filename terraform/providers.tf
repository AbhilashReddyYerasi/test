provider "azurerm" {
  features {}
  skip_provider_registration = true
  use_oidc                   = true
}

provider "snowflake" {
  role          = "ACCOUNTADMIN"
  alias         = "account_admin"
  authenticator = "JWT"
}

provider "snowflake" {
  role          = "LOADER"
  alias         = "loader"
  authenticator = "JWT"
}