variable provider_alicloud_region {
  description = "For the provider Information"
  default = "ap-southeast-5"
}

variable "vpc" {
  description = "detail all the VPC"
  type = object({
    cidr_block = string
    name = string
  })
  default = {
    cidr_block = "172.16.0.0/16"
    name = "tf-vpc"
  }
}

variable "vswitch_node" {
  description = "detail all the Vswitch node worker"
  type = object({
    cidr_block = string
    avail_zone = string
  })
  default = {
    cidr_block = "172.16.24.0/24"
    avail_zone = "ap-southeast-5b"
  }
}

variable "vswitch_pod" {
  description = "detail all the Vswitch pods"
  type = object({
    cidr_block = string
    avail_zone = string
  })
  default = {
    cidr_block = "172.16.64.0/19"
    avail_zone = "ap-southeast-5b"
  }
}

variable "cluster_name" {
  description = "For the cluster kubernetes name"
  default = "my-kubernetes"
}

variable worker {
  description = "All about worker Information"
  type = object({
    version = string
    total_node = number
    service_cidr = string
    charge_type = string
    disk_size = number
    disk_category = string
    data_disk_category = string
    image_id = string
    password = string
  })
  default = {
    version = "1.14.8-aliyun.1"
    total_node = 2
    service_cidr = "192.168.128.0/18"
    charge_type = "PostPaid"
    disk_category  = "cloud_efficiency"
    data_disk_category = "cloud_efficiency"
    disk_size = 20
    image_id = "centos_7_7_x64_20G_alibase_20200426.vhd"
    password = "Demokubernetes123"
  }
}

variable "cluster_addons" {
  description = "All about worker Add-Ons nformation"
  type = list(object({
    name      = string
    config    = string
  }))
## Network Detail
### terway - split vswitch subnet for node worker and pods
### flannel - node worker and pods IP using same subnet
  default = [
    {
      "name"     = "terway-eniip",
      "config"   = "",
    },
    {
      "name"     = "logtail-ds",
      "config"   = "my-kubernetes-demo",
    },
  ]
}