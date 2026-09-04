
## VARIABLES for WINDOWS Instance
variable "windows_username" {
  type    = string
  default = "KANRISHA"
}
variable "windows_password" {
  type      = string
  sensitive = true
}