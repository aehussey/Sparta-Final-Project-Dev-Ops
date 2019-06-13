variable "name" {
  default="app-aaron"
}

variable "app_ami_id" {
  default="ami-020fc26077d248769"
}

variable "db_ami_id" {
  default="ami-0665c2aeb3fca9060"
}

variable "cidr_block" {
  default="10.17.0.0/16"
}
