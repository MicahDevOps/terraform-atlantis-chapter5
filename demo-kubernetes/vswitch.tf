## Create vswitch for node worker
resource "alicloud_vswitch" "node_vswitch" {
  name = "${var.cluster_name}-node"
  vpc_id = data.alicloud_vpcs.my_kubernetes.ids.0
  cidr_block = var.vswitch_node.cidr_block
  availability_zone = var.vswitch_node.avail_zone
}

## Create vswitch for kubernetes pods
resource "alicloud_vswitch" "pod_vswitch" {
  name = "${var.cluster_name}-pod"
  vpc_id = data.alicloud_vpcs.my_kubernetes.ids.0
  cidr_block = var.vswitch_pod.cidr_block
  availability_zone = var.vswitch_pod.avail_zone
}