
# ## Variables For Regions
# variable "aws_region_var" {
#   type = string
# }


## Variable for INSTANCES' Instance Type, Volume_size & Volume_Type


### INSTANCE TYPES: "t2.micro", "t3.micro", "t2.nano" etc...
### Condition: Only supports volume type having t2.micro & t3.micro....
variable "ec2_instance_type_var" {
  type = string
  # default = "t2.micro"

  validation {
    condition = var.ec2_instance_type_var == "t2.micro" || var.ec2_instance_type_var == "t3.micro"
    # condition = contains(["t2.micro","t3.micro"], var.ec2_instance_type_var)      ###above can be written in this FORMAT!
    error_message = "Only supports volume type having t2.micro & t3.micro."
  }


}

### VOLUME SIZE TYPES: "gp2", "gp3" etc...
variable "ec2_volume_type_var" {
  type    = string
  default = "gp3"

}

### VOLUME SIZE TYPES: "t2.micro", "t3.micro", "t2.nano" etc...
### Condition: EC2 Volume size must be GREATER THAN 50 GB while declaring...
variable "ec2_volume_size_var" {
  type = number
  # default = 50

  validation {
    condition     = var.ec2_volume_size_var >= 50
    error_message = "EC2 Volume size must be GREATER THAN 50 GB while declaring..."
  }


}

