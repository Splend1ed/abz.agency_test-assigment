output "id" {
  value = aws_vpc.vpc.id
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.private[*].id
}

output "db_subnet_group_name" {
  value = aws_db_subnet_group.this.name
}

output "elasticache_subnet_group_name" {
  value = aws_elasticache_subnet_group.this.name
}
