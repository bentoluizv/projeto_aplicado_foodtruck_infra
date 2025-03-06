variable "username" {
  type    = string
  default = "admin"
}

variable "password" {
  type      = string
  sensitive = true
}

variable "database_name" {
  type    = string
  default = "main"
}
variable "network_id" {
  type = string
}
