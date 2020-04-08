variable "enable" {
  type    = bool
  default = false
}
variable "release_name" {
  type    = string
  default = "mysql"
}
variable "root_password" {
  type    = string
  default = ""
}
variable "init_pod_registry" {
  type    = string
  default = "docker.io"
}
variable "init_pod_image_repository" {
  type    = string
  default = "bitnami/minideb"
}
variable "init_pod_image_tag" {
  type    = string
  default = "buster"
}
variable "limit_cpu" {
  type    = string
  default = "250m"
}
variable "limit_memory" {
  type    = string
  default = "512Mi"
}
variable "request_cpu" {
  type    = string
  default = "250m"
}
variable "request_memory" {
  type    = string
  default = "512Mi"
}
variable "enable_persistence" {
  type    = bool
  default = false
}
variable "namespace" {
  type    = string
  default = "default"
}
variable "fullname" {
  type    = string
  default = "mysql"
}
data "template_file" "master_resource" {
  template = file("${path.module}/master_resource.yaml")
  vars     = {
    limit_cpu      = var.limit_cpu
    limit_memory   = var.limit_memory
    request_cpu    = var.request_cpu
    request_memory = var.request_memory
  }
}
variable "mysql_image_registry" {
  type    = string
  default = "docker.io"
}
variable "mysql_image_repository" {
  type = string
  default = "bitnami/mysql"
}
variable "mysql_image_tag" {
  type = string
  default = "5.7"
}
resource "helm_release" "mysql" {
  count     = var.enable ? 1 : 0
  chart     = path.module
  name      = var.release_name
  namespace = var.namespace
  set {
    name  = "fullnameOverride"
    value = var.fullname
  }
  set {
    name  = "root.password"
    value = var.root_password
  }
  set {
    name  = "volumePermissions.enabled"
    value = true
  }
  set {
    name  = "volumePermissions.image.registry"
    value = var.init_pod_registry
  }
  set {
    name  = "volumePermissions.image.repository"
    value = var.init_pod_image_repository
  }
  set {
    name  = "volumePermissions.image.tag"
    value = var.init_pod_image_tag
  }
  set {
    name  = "replication.enabled"
    value = false
  }
  set {
    name  = "image.registry"
    value = var.mysql_image_registry
  }
  set {
    name  = "image.repository"
    value = var.mysql_image_repository
  }
  set {
    name  = "image.tag"
    value = var.mysql_image_tag
  }
  values    = [
    data.template_file.master_resource.rendered
  ]
  set {
    name  = "master.persistence.enabled"
    value = var.enable_persistence
  }
}

data "kubernetes_secret" "root_password" {
  count      = var.enable ? 1 : 0
  depends_on = [
    helm_release.mysql]
  metadata {
    name      = var.fullname
    namespace = var.namespace
  }
}

output "username" {
  depends_on = [
    helm_release.mysql]
  value      = "root"
}

output "password" {
  value = var.enable ? (var.root_password == "" ? data.kubernetes_secret.root_password.*.data[0]["mysql-root-password"] : var.root_password) : ""
}
