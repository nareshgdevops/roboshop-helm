provider "helm" {
  kubernetes = {
    config_path = "~/.kube/config"
  }
}

provider "azurerm" {
  features {}
  subscription_id = "ddffee8a-e239-4aa1-b7e0-b88ff5a2f9aa"
}
terraform {
  backend "azurerm" {}
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "4.8.0"
    }
  }
}

provider "vault" {
  address = "http://vault-int.nareshdevops1218.online:8200"
  token   = var.token
}