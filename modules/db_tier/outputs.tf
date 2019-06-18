output "db_instance" {
  value = "${aws_instance.db.0.private_ip}"
}
