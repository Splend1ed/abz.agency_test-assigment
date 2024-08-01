variable "name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "db_name" {
  type = string
}

variable "availability_zone" {
  type = string
}

variable "allocated_storage" {
  type = string
  default = 20
}

variable "engine_version" {
  type = string
  default = "8.0"
}

variable "instance_class" {
  type = string
  default = "db.t3.micro"
}

variable "username" {
  type = string
}

variable "password" {
  type = string
}

variable "db_subnet_group_name" {
  type = string
}
