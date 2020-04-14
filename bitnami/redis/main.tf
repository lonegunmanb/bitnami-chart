data "template_file" "resource" {
  template = file("${path.module}/resource.yaml.tplt")
  vars = {
    request_cpu = var.request_cpu
    request_memory = var.request_memory
    limit_cpu = var.limit_cpu
    limit_memory = var.limit_memory
  }
}

resource "helm_release" "redis" {
  depends_on = [var.module_depends_on]
  count = var.enabled ? 1 : 0
  chart = path.module
  name  = var.release_name
  namespace = var.namespace
  set {
    name  = "cluster.slaveCount"
    value = var.slaveCount
  }
  set {
    name  = "metrics.enabled"
    value = false
  }
  set {
    name  = "volumePermissions.enabled"
    value = true
  }
  set {
    name  = "usePassword"
    value = true
  }
  set {
    name = "password"
    value = var.password
  }
  set {
    name = "image.registry"
    value = var.image_registry
  }
  set {
    name  = "image.repository"
    value = var.image_repository
  }
  set {
    name  = "image.tag"
    value = var.image_tag
  }
  set {
    name = "fullnameOverride"
    value = var.fullname
  }
  values = [
    "master:\n${data.template_file.resource.rendered}",
    "slave:\n${data.template_file.resource.rendered}"
  ]
}
