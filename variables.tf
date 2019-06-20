variable "name" {
  default="elkattempt"
}

variable "app_ami_id" {
  default="ami-0960c41aea0017088"
}

variable "db_ami_id" {
  default="ami-09b3f834e7dbeb491"
}

variable "cidr_block" {
  default="10.17.0.0/16"
}
