variable "name" {
  default="elkattempt"
}

variable "app_ami_id" {
  default="ami-0960c41aea0017088"
}

variable "db_ami_id" {
  default="ami-0f8fd53560ca320f6"
}

variable "cidr_block" {
  default="10.17.0.0/16"
}
