terraform {
  required_version = ">= 1.3"

  backend "azurerm" {
    use_oidc = true
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.26.0"
    }

    snowflake = {
      source  = "snowflake-labs/snowflake"
      version = "0.89.0"
    }
  }
}
