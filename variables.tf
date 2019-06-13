variable "name" {
  default="app-aaron"
}

variable "app_ami_id" {
  default="ami-03e3239774cb68a47"
}

variable "db_ami_id" {
  default="ami-01020378"
}

variable "cidr_block" {
  default="10.17.0.0/16"
}
