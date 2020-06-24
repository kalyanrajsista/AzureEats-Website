terraform {
  backend "azurerm" {
    resource_group_name  = "tf-challenge-remotestate-rg"
    storage_account_name = "tfchallengeremotestate"
    container_name       = "tfchallenge-tfstate"
    key                  = "core.tfchallenge.tfstate"
  }
}
