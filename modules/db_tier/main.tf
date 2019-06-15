# DB
# create a subnet
resource "aws_subnet" "db" {
  count = 3
  vpc_id = "${var.app_vpc}"
  cidr_block = "${element(var.subnets, count.index)}"
  map_public_ip_on_launch = true
  availability_zone = "${element(var.availability_zones, count.index)}"
  tags = {
    Name = "${var.name}-db-${count.index}"
  }
}

# security
resource "aws_security_group" "db"  {
  name = "${var.name}-db"
  description = "${var.name} db access"
  vpc_id = "${var.app_vpc}"

  ingress {
    from_port       = "27017"
    to_port         = "27017"
    protocol        = "tcp"
    security_groups = ["${var.security_groups}"]
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
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name}-db"
  }
}

resource "aws_network_acl" "db" {
  count = 3
  vpc_id = "${var.app_vpc}"

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "${var.subnet_cidr_blocks[count.index]}"
    from_port  = 27017
    to_port    = 27017
  }

  # EPHEMERAL PORTS

  egress {
    protocol   = "tcp"
    rule_no    = 120
    action     = "allow"
    cidr_block = "${var.subnet_cidr_blocks[count.index]}"
    from_port  = 1024
    to_port    = 65535
  }

  egress {
    protocol   = "tcp"
    rule_no    = 130
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 22
    to_port    = 22
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 130
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 22
    to_port    = 22
  }

  subnet_ids   = ["${aws_subnet.db[count.index].id}"]

  tags = {
    Name = "${var.name}-db-${count.index}"
  }
}

# public route table
resource "aws_route_table" "db" {
  vpc_id = "${var.app_vpc}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${var.internet_gateway}"
  }

  tags = {
    Name = "${var.name}-db-private"
  }
}

resource "aws_route_table_association" "db" {
  count = 3
  subnet_id      = "${aws_subnet.db[count.index].id}"
  route_table_id = "${aws_route_table.db.id}"
}

# launch an instance
resource "aws_instance" "db" {
  count = 3
  ami           = "${var.db_ami_id}"
  subnet_id     = "${aws_subnet.db[count.index].id}"
  vpc_security_group_ids = ["${aws_security_group.db.id}"]
  instance_type = "t2.micro"
  key_name = "${var.key_name}"
  tags = {
      Name = "${var.name}-db-${count.index}"
  }
}
