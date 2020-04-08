variable "namespace" {
  type    = string
  default = "default"
}
variable "replicas" {
  type    = number
  default = 3
}
variable "rabbitmq_registry" {
  default = "docker.io"
}
variable "rabbitmq_image" {
  type    = string
  default = "bitnami/rabbitmq"
}
variable "rabbitmq_image_tag" {
  type    = string
  default = "3.8.2"
}
variable "init_pod_image_registry" {
  type    = string
  default = "docker.io"
}
variable "init_pod_image" {
  type    = string
  default = "bitnami/minideb"
}
variable "init_pod_image_tag" {
  type    = string
  default = "stretch"
}
variable "password" {
  type = string
}
variable "username" {
  type = string
  default = "user"
}
variable "storage_class" {
  type = string
  default = ""
}
variable "storage_size" {
  type = string
  default = "20Gi"
}
// on normal k8s, you should install ingress controller first; alicloud serverless k8s will create ingress controller dynamically
variable "enable_ui" {
  type = bool
  default = false
}
variable "rabbitmq_port" {
  type = number
  default = 5672
}
variable "rabbitmq_manager_ui_port" {
  type = number
  default = 15672
}
variable "request_memory" {
  type = string
  default = "128Mi"
}

variable "request_cpu" {
  type = string
  default = "250m"
}

variable "limit_memory" {
  type = string
  default = "256Mi"
}

variable "limit_cpu" {
  type = string
  default = "500m"
}
variable "fullname" {
  default = "rabbitmq"
}
variable "consul_svc" {
  default = ""
}
variable release_name {
  type    = string
  default = "rabbitmq"
}
variable "enable" {
  type = bool
  default = true
}
