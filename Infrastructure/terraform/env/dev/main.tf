terraform {
  backend "azurerm" {
    required_version     = ">=1.0"
    container_name       = "<ContainerNameTerraformStateFile>"
    key                  = "dev.terraform.tfstate"
  }
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.23.0"
    }
  }
}

provider "azurerm" {
  skip_provider_registration = true
  features {}
}

variable "environment" {
  type    = string
  default = "Development"
}

variable "env" {
  type    = string
  default = "dev"
}

variable "location" {
  type    = string
  default = "westeurope"
}
