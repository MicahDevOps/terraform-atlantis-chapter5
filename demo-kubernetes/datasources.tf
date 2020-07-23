## data sources to get Existing VPC information
data "alicloud_vpcs" "my_kubernetes" {
  cidr_block = "${var.vpc.cidr_block}"
  status     = "Available"
  name_regex = "${var.vpc.name}"
}

## data sources to get available zone
data "alicloud_zones" "my_kubernetes" {
  available_instance_type = data.alicloud_instance_types.my_kubernetes.ids[0]
}

## data sources to select specific instances type
data "alicloud_instance_types" "my_kubernetes" {
  cpu_core_count = 4
  memory_size = 8
  instance_type_family = "ecs.c6"
  kubernetes_node_role = "Worker"
}