
variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}



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
  alias                = "ash"
}

data "oci_identity_availability_domains" "ashburn" {
  provider             = "oci.ash"
  compartment_id       = "${var.tenancy_ocid}"
}

provider "oci" {
  version              = ">= 3.0.0"
  tenancy_ocid         = "${var.tenancy_ocid}"
  user_ocid            = "${var.user_ocid}"
  fingerprint          = "${var.fingerprint}"
  private_key_path     = "${var.private_key_path}"
  region               = "eu-frankfurt-1"
  alias                = "fra"
}

data "oci_identity_availability_domains" "frankfurt" {
  provider            = "oci.fra"
  compartment_id      = "${var.tenancy_ocid}"
}
### Network Variables ##### 

variable "vcn_cidr_block" {
  default = "10.1.0.0/16"
}

variable "dns_label_vcn" {
  default = "dnsvcn"
}

variable "subnet_cidr_block" {
  default = "10.1.10.0/24"
}

variable "dns_label_subnet" {
  default = "subnet"
}

variable "instance_shape" {
  default = "VM.Standard2.1"
}

variable "count" {
  default = 2
}

