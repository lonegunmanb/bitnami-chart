data template_file extra_config {
  template = file("${path.module}/extra_config")
  vars = {
    consul_svc = local.consul_svc
  }
}

data "template_file" "pod_resource" {
  template = file("${path.module}/pod_resource")
  vars     = {
    request_memory = var.request_memory
    request_cpu    = var.request_cpu
    limits_memory  = var.limit_memory
    limits_cpu     = var.limit_cpu
  }
}

resource "helm_release" "rabbitmq" {
  depends_on = [var.module_depends_on]
  count = var.enable ? 1 : 0
  chart     = path.module
  name      = var.release_name
  namespace = var.namespace
  set {
    name  = "fullnameOverride"
    value = var.fullname
  }
  set {
    name  = "rabbitmq.clustering.k8s_domain"
    value = ""
  }
  set {
    name  = "replicas"
    value = var.replicas
  }
  set {
    name  = "image.registry"
    value = var.rabbitmq_registry
  }
  set {
    name  = "image.repository"
    value = var.rabbitmq_image
  }
  set {
    name  = "image.tag"
    value = var.rabbitmq_image_tag
  }
  set {
    name  = "volumePermissions.image.registry"
    value = var.init_pod_image_registry
  }
  set {
    name  = "volumePermissions.image.repository"
    value = var.init_pod_image
  }
  set {
    name  = "volumePermissions.image.tag"
    value = var.init_pod_image_tag
  }
  set {
    name  = "rabbitmq.username"
    value = var.username
  }
  set {
    name  = "rabbitmq.password"
    value = var.password
  }
  set {
    name  = "nodeSelector"
    value = ""
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
    name  = "global.storageClass"
    value = var.storage_class
  }
  set {
    name  = "persistence.storageClass"
    value = var.storage_class
  }
  set {
    name  = "persistence.size"
    value = var.storage_size
  }
  set {
    name  = "rabbitmq.plugins"
    value = "rabbitmq_management rabbitmq_peer_discovery_consul"
  }
  set {
    name  = "rabbitmq.extraConfiguration"
    value = data.template_file.extra_config.rendered
  }
  set {
    name  = "service.port"
    value = var.rabbitmq_port
  }
  set {
    name  = "service.managerPort"
    value = var.rabbitmq_manager_ui_port
  }
  set {
    name  = var.extra_plugins == "" ? "extraPlugin"/*won't take effect*/ : "rabbitmq.extraPlugins"
    value = var.extra_plugins
  }
  values = [
    data.template_file.pod_resource.rendered,
  ]
}

resource "kubernetes_ingress" "rabbitmq_mgr_ui" {
  count      = var.enable && var.enable_ui ? 1 : 0
  depends_on = [helm_release.rabbitmq]
  metadata {
    name      = "rabbitmq-ui-${var.namespace}"
    namespace = var.namespace
  }
  spec {
    rule {
      host = "test-rabbitmq-${var.namespace}.lumous.cn"
      http {
        path {
          path = "/"
          backend {
            service_name = "rabbitmq"
            service_port = var.rabbitmq_manager_ui_port
          }
        }
      }
    }
  }
}

output "rabbitmq_svc" {
  depends_on = [helm_release.rabbitmq]
  value = var.enable ? "${var.fullname}.${var.namespace}" : ""
}

output "rabbitmq_port" {
  depends_on = [helm_release.rabbitmq]
  value = var.enable ? var.rabbitmq_port : ""
}

output "rabbitmq_ui_port" {
  depends_on = [helm_release.rabbitmq]
  value = var.enable ? var.rabbitmq_manager_ui_port : ""
}

output "revision" {
  value = var.enable && length(helm_release.rabbitmq) > 0 ? helm_release.rabbitmq[0].metadata[0].revision : ""
}

output "version" {
  value = var.enable && length(helm_release.rabbitmq) > 0 ? helm_release.rabbitmq[0].metadata[0].version : ""
}
