module "app" {
  source ="./modules/app_tier"
  name = "${var.name}"
  app_ami_id = "${var.app_ami_id}"
  cidr_block = "${var.cidr_block}"
  db_ami_id = "${var.db_ami_id}"
  app_vpc = "${aws_vpc.app.id}"
  internet_gateway = "${aws_internet_gateway.app.id}"
  template_file = "${data.template_file.app_init.*.rendered}"
  key_name = "${aws_key_pair.default.key_name}"
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
  key_name = "${aws_key_pair.default.key_name}"
  internet_gateway = "${aws_internet_gateway.app.id}"
}

# Route 53
provider "aws" {
  region  = "eu-west-1"
}

locals {
  domain_name = "spartaglobal.education."
  record_name = "engineering29-devops"
}

data "aws_route53_zone" "hosted_zone" {
  name = "${local.domain_name}"
}

data "http" "ip" {
  url = "https://ipv4.icanhazip.com"
}

resource "aws_route53_record" "dns_record" {
  # Use the ID of the Hosted Zone we retrieved earlier
  zone_id = "${data.aws_route53_zone.hosted_zone.zone_id}"

  # Set the name of the record, e.g. pc.mydomain.com
  name = "${local.record_name}.${local.domain_name}"

  # We're pointing to an IP address so we need to use an A record
  type = "A"

  # We'll set the TTL of the record to 30 minutes (1800 seconds)
  ttl = "1800"

  # Set the content of the record to the IP address obtained from icanhazip.com
  # The chomp function strips out any newlines from the data
  records = ["${chomp(data.http.ip.body)}"]
}




# create a vpc
resource "aws_vpc" "app" {
  cidr_block = "${var.cidr_block}"
  enable_dns_hostnames = true
  enable_dns_support   = true

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

resource "aws_key_pair" "default" {
  key_name = "Eng29-final-project-JB"
  public_key = "${file("~/.ssh/id_rsa.pub")}"
}

# load the init template
data "template_file" "app_init" {
count = 3
template = "${file("./scripts/app/init.sh.tpl")}"
vars = {
db_host="mongodb://${element(module.db.db_instance, count.index)}:27017/posts"
}
}
