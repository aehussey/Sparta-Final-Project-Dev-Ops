variable "name" {
  default="elk_attempt"
}

variable "app_ami_id" {
  default="ami-031addfc78bcdf57d"
}

variable "db_ami_id" {
  default="ami-0f8fd53560ca320f6"
}

variable "cidr_block" {
  default="10.17.0.0/16"
}
