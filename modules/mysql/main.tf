resource "aws_security_group" "this" {
  name   = "${var.name}-mysql"
  vpc_id = var.vpc_id
}

resource "aws_db_instance" "this" {
  identifier             = var.name
  allocated_storage      = var.allocated_storage
  availability_zone      = var.availability_zone
  db_name                = var.db_name
  engine                 = "mysql"
  engine_version         = var.engine_version
  instance_class         = var.instance_class
  username               = var.username
  password               = var.password
  db_subnet_group_name   = var.db_subnet_group_name
  vpc_security_group_ids = [aws_security_group.this.id]
  skip_final_snapshot    = true
}
