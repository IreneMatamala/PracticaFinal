terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "aa9408e4-354b-46bd-af99-ef533fa2b812"
}

resource "azurerm_resource_group" "main" {
  name     = "techwave-rg"
  location = "westeurope"
}





