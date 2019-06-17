output "db_instance" {
  value = "${aws_instance.db.*.private_ip}"
}
