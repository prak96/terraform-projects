
## Random suffix for globally unique names
resource "random_id" "myrandom" {
  byte_length = 5

  keepers = {
    project = var.projectName
    environment = var.envName
  }
}


locals {
  ### Common Tags applied to all resources
  universal_tags = merge(var.tagList, {
    environment = var.envName
    project     = var.projectName
    managedBy = "Terraform"
  })

  ### Naming Convention
  name_prefix = "${var.projectName}-${var.envName}"

  ### Network Configuration
  vpc_name = "${local.name_prefix}-vpc"


  ### Storage configuration
  bucket_name = "${local.name_prefix}-${random_id.myrandom.hex}"

}






