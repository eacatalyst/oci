#!/bin/bash 

echo This script will install terraform and oci-cli on oracle linux.
echo WARNING - THIS SCRIPT WILL OVERWRITE ~/.ssh/id_rsa and ~/.ssh/id_rsa.pub
echo
read -p "Press enter to continue"

#sudo yum -y makecache
#sudo yum -y upgrade
#sudo yum -y update

sudo yum -y install terraform python-oci-cli bzip2 cpio zip unzip dos2unix dialog curl jq git golang iputils wget screen tmux byobu elinks

yes "y" | ssh-keygen -N "" -f ~/.ssh/id_rsa

#generate API keys
mkdir -p ~/.oci 
#Private Key
openssl genrsa -out ~/.oci/oci_api_key.pem 2048
chmod 0700 ~/.oci
chmod 0600 ~/.oci/oci_api_key.pem
#Public Key
openssl rsa -pubout -in ~/.oci/oci_api_key.pem -out ~/.oci/oci_api_key_public.pem
#Fingerprint
openssl rsa -in ~/.oci/oci_api_key.pem -pubout -outform DER 2>/dev/null | openssl md5 -c | awk '{print $2}' > ~/.oci/oci_api_key_fingerprint
chmod 0600 ~/.oci/oci_api_key_public.pem
chmod 0600 ~/.oci/oci_api_key_fingerprint

mkdir -p terraformtest

command cat >~/terraformtest/provider.tf <<'EOF'
variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}
variable "compartment_ocid" {}
variable "ssh_public_key" {}
variable "region" {}

provider "oci" {
  tenancy_ocid         = "${var.tenancy_ocid}"
  user_ocid            = "${var.user_ocid}"
  fingerprint          = "${var.fingerprint}"
  private_key_path     = "${var.private_key_path}"
  region               = "${var.region}"
  disable_auto_retries = "true"
}

data "oci_identity_availability_domains" "ADs" {
  compartment_id = "${var.tenancy_ocid}"
}

output "ADprint" {
  value = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[0],"name")}"
}
EOF

command cat>~/terraformtest/env-vars <<'EOF'
export TF_VAR_tenancy_ocid=ocid1.tenancy.oc1..aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
export TF_VAR_user_ocid=ocid1.user.oc1..aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
export TF_VAR_compartment_ocid=ocid1.compartment.oc1..aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa

#export TF_VAR_fingerprint=$(openssl rsa -in ~/.oci/oci_api_key.pem -pubout -outform DER 2>/dev/null | openssl md5 -c | awk '{print $2}')
#"openssl rsa -in ~/.oci/oci_api_key.pem -pubout -outform DER 2>/dev/null | openssl md5 -c | awk '{print $2}' > ~/.oci/oci_api_key_fingerprint"
export TF_VAR_fingerprint=$(cat ~/.oci/oci_api_key_fingerprint)

export TF_VAR_private_key_path=~/.oci/oci_api_key.pem

export TF_VAR_ssh_public_key=$(cat ~/.ssh/id_rsa.pub)
export TF_VAR_ssh_private_key=$(cat ~/.ssh/id_rsa)

export TF_VAR_region=us-phoenix-1
EOF


echo 
echo Terraform and OCI CLI have been installed. 
echo The API Keys have been generated, and are saved at ~/.oci/ 
echo
echo Contents of the API Public Key
echo
cat ~/.oci/oci_api_key_public.pem 
echo
echo
echo Contents of the API Key Fingerprint. 
echo
cat ~/.oci/oci_api_key_fingerprint
echo
echo
echo
