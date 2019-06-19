resource "aws_subnet" "elk_stack" {
  vpc_id = "${var.app_vpc}"
  cidr_block = "${var.subnet}"
  map_public_ip_on_launch = true
  availability_zone = "${var.availability_zones.1}"
  tags = {
    Name = "${var.name}-elk_stack"
  }
}

# security
resource "aws_security_group" "elk_stack"  {
  name = "${var.name}-elk_stack"
  description = "${var.name} elk_stack access"
  vpc_id = "${var.app_vpc}"


  ingress {
    from_port       = "22"
    to_port         = "22"
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = "5601"
    to_port         = "5601"
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }



  ingress {
    from_port       = "5044"
    to_port         = "5044"
    protocol        = "tcp"
    cidr_blocks     = ["10.17.0.0/16"]
  }



  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 5044
    to_port         = 5044
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }


  egress {
    from_port       = "22"
    to_port         = "22"
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name}-elk"
  }
}

# public route table
resource "aws_route_table" "elk_stack" {
  vpc_id = "${var.app_vpc}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${var.internet_gateway}"
  }

  tags = {
    Name = "${var.name}-elk"
  }
}

resource "aws_route_table_association" "elk_stack" {
  subnet_id      = "${aws_subnet.elk_stack.id}"
  route_table_id = "${aws_route_table.elk_stack.id}"
}


# launch an instance
resource "aws_instance" "elk_stack" {
  ami = "ami-0d87444e352614a7a"
  subnet_id = "${aws_subnet.elk_stack.id}"
  vpc_security_group_ids = ["${aws_security_group.elk_stack.id}"]
  instance_type = "t2.small"
  private_ip= "10.17.45.80"
  key_name = "${var.key_name}"
  tags = {
      Name = "${var.name}-elk_stack"
  }
}
