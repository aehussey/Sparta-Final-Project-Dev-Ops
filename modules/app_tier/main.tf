# APP
# create a subnet
resource "aws_subnet" "app" {
  count = 3
  vpc_id = "${var.app_vpc}"
  cidr_block = "${element(var.subnets, count.index)}"
  map_public_ip_on_launch = true
  availability_zone = "${element(var.availability_zones, count.index)}"
  tags = {
    Name = "${var.name}-${count.index}"
  }
}

# security
resource "aws_security_group" "app"  {
  name = "${var.name}"
  description = "${var.name} access"
  vpc_id = "${var.app_vpc}"

  ingress {
    from_port       = "80"
    to_port         = "80"
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = "22"
    to_port         = "22"
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  egress {
    from_port       = "22"
    to_port         = "22"
    protocol        = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "${var.name}"
  }
}

resource "aws_network_acl" "app" {
  count = 3
  vpc_id = "${var.app_vpc}"

  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }

  # EPHEMERAL PORTS

  egress {
    protocol   = "tcp"
    rule_no    = 120
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 120
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }

  egress {
    protocol = "tcp"
    rule_no = 130
    action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port = 22
    to_port = 22
  }

  ingress {
    protocol = "tcp"
    rule_no = 130
    action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port = 22
    to_port = 22
  }

  subnet_ids   = ["${aws_subnet.app[count.index].id}"]

  tags = {
    Name = "${var.name}-${count.index}"
  }
}

# public route table
resource "aws_route_table" "app" {
  vpc_id = "${var.app_vpc}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${var.internet_gateway}"
  }

  tags = {
    Name = "${var.name}-public"
  }
}

resource "aws_route_table_association" "app" {
  count = 3
  subnet_id      = "${aws_subnet.app[count.index].id}"
  route_table_id = "${aws_route_table.app.id}"
}

# launch configuration
resource "aws_launch_configuration" "app" {
  image_id           = "${var.app_ami_id}"
  security_groups = ["${aws_security_group.app.id}"]
  user_data = "${var.template_file.0}"
  instance_type = "t2.micro"
  key_name = "${var.key_name}"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "app" {
  launch_configuration = "${aws_launch_configuration.app.id}"
  availability_zones = "${var.availability_zones.*}"
  min_size = 3
  max_size = 3
  vpc_zone_identifier = "${aws_subnet.app.*.id}"

  load_balancers = ["${aws_elb.app.name}"]
  health_check_type = "ELB"

  tag {
      key = "Name"
      value = "${var.name}"
      propagate_at_launch = true
  }
}

resource "aws_elb" "app" {
  name = "${var.name}"
  security_groups = ["${aws_security_group.app.id}"]
  subnets = "${aws_subnet.app.*.id}"

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 5
    interval = 30
    target = "HTTP:80/"
  }

  listener {
    lb_port = 80
    lb_protocol = "http"
    instance_port = 80
    instance_protocol = "http"
  }
}
