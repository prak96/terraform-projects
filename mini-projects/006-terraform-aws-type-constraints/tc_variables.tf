## Will be used as CONCATENATION
variable "projectName" {
  type        = string
  description = "Enter the PROJECT Name"
}
variable "envName" {
  type        = string
  description = "Enter the ENVIRONMENT for resource deployment"

  validation {
    condition     = contains(["DEV", "PROD", "TEST"], var.envName)
    error_message = "ENVIRONMENT must be DEV, PROD & TEST"
  }
}
variable "tagList" {
  type        = map(string)
  default     = {}
  description = "Additional tags to be applied"
}


## REGION Variables
variable "region-var" {
  type    = string
  default = "us-east-1"

  validation {
    condition     = contains(["us-east-1", "us-west-1", "eu-central-1", "eu-west-1", "eu-north-1", "ap-south-1"], var.region-var)
    error_message = "Enter region which are present in this list"
  }
}


variable "vpc_cidr" {
  default     = "172.27.0.0/16"
  type        = string
  description = "Enter CIDR value of VPC"

  validation {
    error_message = "VPC CIDR must be valid IPv4"
    condition     = can(cidrhost(var.vpc_cidr, 0))
  }
}




