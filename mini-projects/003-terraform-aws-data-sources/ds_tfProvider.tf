
## Setting Providers with REGION

terraform {
  required_version = ">1.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>5.0"
    }
  }
}

## A default PROVIDER
provider "aws" {
  region = "us-east-1" ## NOTE: No ALIAS is included  in Default REGIONAL Provider
}

provider "aws" {
  region = "us-east-1"
  alias  = "eastus"
}

provider "aws" {
  region = "eu-west-1"
  alias  = "westeu"
}