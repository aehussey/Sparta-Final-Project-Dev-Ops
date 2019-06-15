variable "name" {
  description = "name of the app"
}

variable "app_ami_id" {
  description = "id of the app ami"

}

variable "db_ami_id" {
  description = "id of the db ami"
}

variable "cidr_block" {
  description = "the cidr_block"
}

variable "app_vpc" {
  description = "app_vpc"
}

variable "security_groups" {
  description = "security_groups"
}

variable "subnet_cidr_blocks" {
  description = "subnet_cidr_block"
}

variable "subnets" {
  type = "list"
  default = ["10.17.1.0/24", "10.17.11.0/24", "10.17.21.0/24"]
}

variable "availability_zones" {
  type = "list"
  default = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
}

variable "key_name" {
  description = "key_name"
}

variable "internet_gateway" {
  description = "internet_gateway"
}
