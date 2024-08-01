resource "aws_security_group" "this" {
  name   = "${var.name}-redis"
  vpc_id = var.vpc_id
}

resource "aws_elasticache_cluster" "this" {
  cluster_id           = var.name
  engine               = "redis"
  node_type            = var.node_type
  num_cache_nodes      = 1
  parameter_group_name = var.parameter_group_name
  engine_version       = var.engine_version
  security_group_ids   = [aws_security_group.this.id]
  availability_zone    = var.availability_zone
  subnet_group_name    = var.subnet_group_name
}
