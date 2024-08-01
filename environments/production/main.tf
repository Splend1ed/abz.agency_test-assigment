locals {
  name              = "assigment-production"
  database_username = "wordpress"
}

data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  source = "../../modules/vpc"

  name               = local.name
  cidr               = "10.0.0.0/16"
  availability_zones = slice(data.aws_availability_zones.available.names, 0, 2)
  public_subnets     = ["10.0.0.0/20", "10.0.16.0/20"]
  private_subnets    = ["10.0.32.0/20", "10.0.48.0/20"]
}

resource "random_password" "password" {
  length  = 16
  special = false
}

module "mysql" {
  source = "../../modules/mysql"

  name                 = local.name
  vpc_id               = module.vpc.id
  db_name              = "wordpress"
  availability_zone    = data.aws_availability_zones.available.names[0]
  username             = local.database_username
  password             = random_password.password.result
  db_subnet_group_name = module.vpc.db_subnet_group_name
}

module "redis" {
  source = "../../modules/redis"

  name              = local.name
  vpc_id            = module.vpc.id
  availability_zone = data.aws_availability_zones.available.names[0]
  subnet_group_name = module.vpc.elasticache_subnet_group_name
}

module "wordpress" {
  source = "../../modules/wordpress"

  name                    = local.name
  vpc_id                  = module.vpc.id
  mysql_security_group_id = module.mysql.security_group_id
  redis_security_group_id = module.redis.security_group_id
}
