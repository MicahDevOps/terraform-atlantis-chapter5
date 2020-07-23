## Set terraform provider for alicloud
provider "alicloud" {
  region = var.provider_alicloud_region
}

## Kubernetes Reseources
resource "alicloud_cs_managed_kubernetes" "my_kubernetes" {
  name = var.cluster_name
  version = var.worker.version
  worker_vswitch_ids = ["${alicloud_vswitch.node_vswitch.id}"]
  pod_vswitch_ids = ["${alicloud_vswitch.pod_vswitch.id}"]
  worker_instance_types = [data.alicloud_instance_types.my_kubernetes.instance_types[0].id]
  worker_number = var.worker.total_node
  service_cidr = var.worker.service_cidr
  worker_instance_charge_type = var.worker.charge_type
  worker_disk_category  = var.worker.disk_category
  worker_disk_size = var.worker.disk_size
  image_id = var.worker.image_id
  password = var.worker.password
  new_nat_gateway = true
  install_cloud_monitor = false
  slb_internet_enabled = false

  dynamic "addons" {
      for_each = var.cluster_addons
      content {
        name                    = lookup(addons.value, "name", var.cluster_addons)
        config                  = lookup(addons.value, "config", var.cluster_addons)
      }
  }
}