output "tf-vpc-id" {
  value = "${data.alicloud_vpcs.my_kubernetes.vpcs.0.id}"
}

output "cluster_name" {
 value = ["${alicloud_cs_managed_kubernetes.my_kubernetes.name}"]
}

output "vswitch_node" {
    value = ["${alicloud_vswitch.node_vswitch.cidr_block}"]
}

output "vswitch_pods" {
    value = ["${alicloud_vswitch.pod_vswitch.cidr_block}"]
}

output "service_cidr" {
    value = ["${alicloud_cs_managed_kubernetes.my_kubernetes.service_cidr}"]
}
    
output "total_node_worker" {
    value = ["${alicloud_cs_managed_kubernetes.my_kubernetes.worker_number}"]
}