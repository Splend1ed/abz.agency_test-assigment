resource "aws_security_group" "this" {
  name   = "${var.name}-wordpress"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "service" {
  for_each = {
    mysql = { id = var.mysql_security_group_id, port = 3306 }
    redis = { id = var.redis_security_group_id, port = 6379 }
  }

  security_group_id        = each.value.id
  type                     = "ingress"
  from_port                = each.value.port
  to_port                  = each.value.port
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.this.id
}

data "aws_ami" "ubuntu" {
  filter {
    name   = "${var.name}-ami"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
  owners = [ "099720109477" ]
  most_recent = true
}

resource "aws_ec2" "this" {
  ami = data.aws_ami.ubuntu.id

  lifecycle {
    ignore_changes = true
  }

}

