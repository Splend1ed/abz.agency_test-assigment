variable "name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "node_type" {
  type = string
  default = "cache.t4g.micro"
}

variable "engine_version" {
  type = string
  default = "7.1"
}

variable "parameter_group_name" {
  type = string
  default = "default.redis7"
}

variable "availability_zone" {
  type = string
}

variable "subnet_group_name" {
  type = string
}
