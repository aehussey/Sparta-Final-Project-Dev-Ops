module "app" {
  source ="./modules/app_tier"
  name = "${var.name}"
  app_ami_id = "${var.app_ami_id}"
  cidr_block = "${var.cidr_block}"
  db_ami_id = "${var.db_ami_id}"
  app_vpc = "${aws_vpc.app.id}"
  internet_gateway = "${aws_internet_gateway.app.id}"
  template_file = "${data.template_file.app_init.*.rendered}"
  key_name = "${aws_key_pair.key.key_name}"
}

module "db" {
  source ="./modules/db_tier"
  name = "${var.name}"
  app_ami_id = "${var.app_ami_id}"
  cidr_block = "${var.cidr_block}"
  db_ami_id = "${var.db_ami_id}"
  app_vpc = "${aws_vpc.app.id}"
  security_groups = "${module.app.security_group_id}"
  subnet_cidr_blocks = "${module.app.subnet_cidr_blocks}"
  key_name = "${aws_key_pair.key.key_name}"
  internet_gateway = "${aws_internet_gateway.app.id}"
}

provider "aws" {
  region  = "eu-west-1"
}

# create a vpc
resource "aws_vpc" "app" {
  cidr_block = "${var.cidr_block}"

  tags = {
    Name = "${var.name}"
  }
}

# internet gateway
resource "aws_internet_gateway" "app" {
  vpc_id = "${aws_vpc.app.id}"

  tags = {
    Name = "${var.name}"
  }
}

# load the init template
data "template_file" "app_init" {
template = "${file("./scripts/app/init.sh.tpl")}"
vars = {
db_host="mongodb://${module.db.db_instance}/24:27017/posts"
}
}

resource "aws_key_pair" "key" {
  key_name = "Eng29-final-project"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDmrGqXggUcawz0zRQywbOXbxft6YhgbZNt45CxrQnlWOMBNxsnGHBaCvstoZpD399PWG3xOQUGIV1z1UWOBQwmWLMQwWz6rbMzJc+Mr8C/DinCakb4DJznGWEib7HrIyaA4gFCUWWm2SKtfwdzVREBM4vOGmVryUZzmpOT5uwa+gGlrhfMeYIfVu4lCNBGhWnh9GlWYcqG4FRQflHuwp9VzZF3Bm+7HFesp2JXL4SgPUqhu5mgEIlpGUfY+LlcqWNW1lROBw4PT4/DSgcP70sTpWnGKNZ9d/f7NbmM6sd9pfyn9DcQr8sxcRrwHJj/Ol3y+dmq6vR48omlqy3o7qs/"
}
