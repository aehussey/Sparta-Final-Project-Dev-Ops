module "app" {
  source ="./modules/app_tier"
  name = "${var.name}"
  app_ami_id = "${var.app_ami_id}"
  cidr_block = "${var.cidr_block}"
  db_ami_id = "${var.db_ami_id}"
  app_vpc = "${aws_vpc.app.id}"
  internet_gateway = "${aws_internet_gateway.app.id}"
  template_file = "${data.template_file.app_init.rendered}"
}

module "db" {
  source ="./modules/db_tier"
  name = "${var.name}"
  app_ami_id = "${var.app_ami_id}"
  cidr_block = "${var.cidr_block}"
  db_ami_id = "${var.db_ami_id}"
  app_vpc = "${aws_vpc.app.id}"
  security_groups = "${module.app.security_group_id}"
  subnet_cidr_block = "${module.app.subnet_cidr_block}"
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
db_host="mongodb://${module.db.db_instance}:27017/posts"
}
}
