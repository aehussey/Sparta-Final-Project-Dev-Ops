variable "name" {
  default="arthur"
}

variable "app_ami_id" {
  default="ami-0cc993bb92cca80d3"
}

variable "db_ami_id" {
  default="ami-0f8fd53560ca320f6"
}

variable "cidr_block" {
  default="10.17.0.0/16"
}
