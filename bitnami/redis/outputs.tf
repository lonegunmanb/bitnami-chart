output "redis_master_svc" {
  depends_on = [helm_release.redis]
  value = "${var.fullname}-master.${var.namespace}"
}

output "redis_slave_svc" {
  depends_on = [helm_release.redis]
  value = "${var.fullname}-slave.${var.namespace}"
}
