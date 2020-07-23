## Store tf state for the kubernetes project to this OSS ##
terraform {
  backend "oss" {
    bucket = "my-kubernetes"
    prefix = "demo"
    key    = "kubernetes.tfstate"
    region = "ap-southeast-5"
  }
  ## Define Specific version alicloud provider version
  required_providers {
    alicloud = {
      version = "= 1.86.0"
    }
  }
}