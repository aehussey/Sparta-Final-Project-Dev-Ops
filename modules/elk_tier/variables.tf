variable "app_vpc" {
  description = "app_vpc"
}

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

variable "internet_gateway" {
  description = "internet_gateway"
}

variable "subnet" {
  default = "10.17.45.0/24"
}

variable "key_name" {
  description = "key_name"
}

variable "availability_zones" {
  type = "list"
  default = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
}
