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
    from_port       = "5044"
    to_port         = "5044"
    protocol        = "tcp"
    cidr_blocks     = ["10.18.0.0/24"]
  }

  ingress {
    from_port       = "5044"
    to_port         = "5044"
    protocol        = "tcp"
    cidr_blocks     = ["10.18.10.0/24"]
  }

  ingress {
    from_port       = "5044"
    to_port         = "5044"
    protocol        = "tcp"
    cidr_blocks     = ["10.18.20.0/24"]
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
    Name = "${var.name}-db"
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
    Name = "${var.name}-public"
  }
}

resource "aws_route_table_association" "elk_stack" {
  subnet_id      = "${aws_subnet.elk_stack.id}"
  route_table_id = "${aws_route_table.elk_stack.id}"
}


# launch an instance
resource "aws_instance" "elk_stack" {
  ami = "ami-02dff0cc503d8a610"
  subnet_id = "${aws_subnet.elk_stack.id}"
  vpc_security_group_ids = ["${aws_security_group.elk_stack.id}"]
  instance_type = "t2.small"
  key_name = "${var.key_name}"
  tags = {
      Name = "${var.name}-elk_stack"
  }
}
