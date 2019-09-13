
variable "region" {}
variable "tenancy_ocid" {}

variable "ssh_public_key" {}

variable "compartment_ocid" {}

provider "oci" {
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
  default = "10.0.10.0/24"
}

variable "subnet_cidr_w2" {
  default = "10.0.20.0/24"
}

variable "instance_shape" {
  default = "VM.Standard1.2"
}


