provider "azurerm" {
  version = "=1.21.0"
}

resource "azurerm_resource_group" "main" {
  name     = "extensions"
  location = "East US"
}

resource "azurerm_app_service_plan" "main" {
  name                = "extensions-asp"
  location            = "${azurerm_resource_group.main.location}"
  resource_group_name = "${azurerm_resource_group.main.name}"

  sku {
    tier = "Free"
    size = "F1"
  }
}

resource "azurerm_app_service" "main" {
  name                = "extensions-as"
  location            = "${azurerm_resource_group.main.location}"
  resource_group_name = "${azurerm_resource_group.main.name}"
  app_service_plan_id = "${azurerm_app_service_plan.main.id}"
  https_only          = true

  site_config {
    use_32_bit_worker_process = true
  }
}

resource "azurerm_template_deployment" "extension" {
  name                = "extension"
  resource_group_name = "${azurerm_resource_group.main.name}"
  template_body       = "${file("arm/siteextensions.json")}"

  parameters {
    "siteName"          = "${azurerm_app_service.main.name}"
    "extensionName"     = "AspNetCoreRuntime.2.2.x86"
    "extensionVersion"  = "2.2.0-preview3-35497"
  }

  deployment_mode     = "Incremental"
}