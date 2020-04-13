variable "enabled" {
  type    = bool
  default = true
}

variable "release_name" {
  type = string
  default = "redis"
}
variable "namespace" {
  type = string
}
variable "slaveCount" {
  type = number
  default = 1
}
variable "password" {
  type = string
}
variable "image_registry" {
  type = string
  default = "docker.io"
}
variable "image_repository" {
  type = string
  default = "bitnami/redis"
}
variable "image_tag" {
  type = string
  default = "5.0.8-debian-10-r21"
}
variable "fullname" {
  type = string
  default = "redis"
}
variable "request_cpu" {
  type = string
  default = "100m"
}
variable "request_memory" {
  type = string
  default = "256Mi"
}
variable "limit_cpu" {
  type = string
  default = "100m"
}
variable "limit_memory" {
  type = string
  default = "256Mi"
}
