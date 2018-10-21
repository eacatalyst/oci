
variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}
variable "region" {}


variable "ssh_private_key" {}
variable "ssh_public_key" {}

variable "compartment_ocid" {}

provider "oci" {
  version              = ">= 3.0.0"
  tenancy_ocid         = "${var.tenancy_ocid}"
  user_ocid            = "${var.user_ocid}"
  fingerprint          = "${var.fingerprint}"
  private_key_path     = "${var.private_key_path}"
  region               = "us-ashburn-1"
}

data "oci_identity_availability_domains" "ashburn" {
  compartment_id       = "${var.tenancy_ocid}"
}

### Network Variables ##### 

variable "vcn_cidr_block" {
  default = "10.0.0.0/16"
}

variable "dns_label_vcn" {
  default = "dnsvcn"
}

variable "subnet_cidr_w1" {
  default = "10.0.1.0/24"
}

variable "subnet_cidr_w2" {
  default = "10.0.2.0/24"
}

variable "subnet_cidr_lb1" {
  default = "10.0.10.0/24"
}

variable "subnet_cidr_lb2" {
  default = "10.0.20.0/24"
}

variable "instance_shape" {
  default = "VM.Standard1.2"
}

variable "cluster_kubernetes_version" {
  default = "v1.11.1"
}

variable "cluster_name" {
  default = "OKE_Cluster"
}

variable "availability_domain" {
  default = 3
}

variable "cluster_options_add_ons_is_kubernetes_dashboard_enabled" {
  default = true
}

variable "cluster_options_add_ons_is_tiller_enabled" {
  default = true
}

variable "cluster_options_kubernetes_network_config_pods_cidr" {
  default = "10.1.0.0/16"
}

variable "cluster_options_kubernetes_network_config_services_cidr" {
  default = "10.2.0.0/16"
}

variable "node_pool_initial_node_labels_key" {
  default = "project"
}

variable "node_pool_initial_node_labels_value" {
  default = "dev"
}

variable "node_pool_kubernetes_version" {
  default = "v1.11.1"
}

variable "node_pool_name" {
  default = "NodePool_1"
}

variable "node_pool_node_image_name" {
  default = "Oracle-Linux-7.5"
}

variable "node_pool_node_shape" {
  default = "VM.Standard1.2"
}

variable "node_pool_quantity_per_subnet" {
  default = 1
}

variable "node_pool_ssh_public_key" {
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDCllzCbs85bP4Ac7twzfcGamxvN3RuyVut8Dij6hY2t+ONYOP8Fjqxc0XyyS0BHpfzhvCvGtuMu6l82wSB2aseH0G4sthPbmTbnvNrOYGm7lf/milApc18DE6IDYlz/obe+l0h6t9mY7lsQxunIKLMvRDfbS1+DjEUU1ohfimMIYTnhje+tvTfZ3sLFS+PPRs+8iAJWT/Ls4EW053coxkfHafGj16UXKVgdONhCpNpS3RaoMqSVSuMwyjQx8fqxMA1pK11jVwBkAX3EDg8YClnMKyKGKCu3suOJuLJGzE72IDUhKVtXj/PQ/2XH7qz4ELMzzLEn4PPgMrnLFN9AHrJ sararif@sararif-mac"
}




