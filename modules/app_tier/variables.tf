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

variable "internet_gateway" {
  description = "internet_gateway"
}

variable "template_file" {
  description = "template_file"
}

variable "key_name" {
  description = "key_name"
}

variable "subnets" {
  type = "list"
  default = ["10.44.0.0/24", "10.44.10.0/24", "10.44.20.0/24"]
}

variable "availability_zones" {
  type = "list"
  default = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
}
