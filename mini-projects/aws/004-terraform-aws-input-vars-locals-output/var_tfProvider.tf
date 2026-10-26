terraform {
  required_version = ">1.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" { ## Default Region
  region = "eu-east-1"
}

provider "aws" {
  region = "eu-east-1"
  alias  = "easteu"
}

provider "aws" {
  region = "us-east-1"
  alias  = "eastus"
}


# provider "aws" { ## Default Region
#   region = var.aws_region_list
# }
