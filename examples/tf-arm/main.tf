provider "azurerm" {
    version = "~>1.19"
}

variable "myList" {
    type = "list"
    default = ["a", "b", "c"]
}

resource "azurerm_resource_group" "main" {
  name     = "MyApp-RG"
  location = "East US"
}

resource "azurerm_template_deployment" "main" {
  name                = "MyApp-ARM"
  resource_group_name = "${azurerm_resource_group.main.name}"

  template_body = "${file("arm/azuredeploy.json")}"

  parameters {
    "myList" = "${join(",", var.myList)}"
  }

  deployment_mode = "Incremental"
}

