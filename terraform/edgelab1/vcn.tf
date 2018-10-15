#### VCN  #######

resource "oci_core_virtual_network" "vcn-ash" {
  provider       = "oci.ash"
  cidr_block     = "${var.vcn_cidr_block}"
  compartment_id = "${var.compartment_ocid}"
  display_name   = "vcn-ash"
  dns_label      = "uswest"

  provisioner "local-exec" {
    command = "sleep 5"
  }
}

resource "oci_core_virtual_network" "vcn-fra" {
  provider       = "oci.fra"
  cidr_block     = "${var.vcn_cidr_block}"
  compartment_id = "${var.compartment_ocid}"
  display_name   = "vcn-fra"
  dns_label      = "eufra"

  provisioner "local-exec" {
    command = "sleep 5"
  }
}

#### Internet Gateay ###

resource "oci_core_internet_gateway" "igw-ash" {
  provider       = "oci.ash"
  compartment_id = "${var.compartment_ocid}"
  display_name   = "igw-ash"
  vcn_id         = "${oci_core_virtual_network.vcn-ash.id}"
}

resource "oci_core_internet_gateway" "igw-fra" {
  provider       = "oci.fra"
  compartment_id = "${var.compartment_ocid}"
  display_name   = "igw-fra"
  vcn_id         = "${oci_core_virtual_network.vcn-fra.id}"
}


#### Route Table #####

resource "oci_core_route_table" "rt1-ash" {
  provider       = "oci.ash"
  compartment_id = "${var.compartment_ocid}"
  vcn_id         = "${oci_core_virtual_network.vcn-ash.id}"
  display_name   = "rt1-ash"

  route_rules {
    destination       = "0.0.0.0/0"
    network_entity_id = "${oci_core_internet_gateway.igw-ash.id}"
  }
}

resource "oci_core_route_table" "rt1-fra" {
  provider       = "oci.fra"
  compartment_id = "${var.compartment_ocid}"
  vcn_id         = "${oci_core_virtual_network.vcn-fra.id}"
  display_name   = "rt1-fra"

  route_rules {
    destination       = "0.0.0.0/0"
    network_entity_id = "${oci_core_internet_gateway.igw-fra.id}"
  }
}

##### Security Lists ######

resource "oci_core_security_list" "sl1-ash" {
  provider       = "oci.ash"
  display_name   = "sl1-ash"
  compartment_id = "${var.compartment_ocid}"
  vcn_id         = "${oci_core_virtual_network.vcn-ash.id}"

  egress_security_rules = [{
    protocol    = "all"
    destination = "0.0.0.0/0"
  }]

  ingress_security_rules = [{
    tcp_options {
      "max" = 22
      "min" = 22
    }

    protocol = "6"
    source   = "0.0.0.0/0"
  },
    {
      icmp_options {
        "type" = 0
      }

      protocol = 1
      source   = "0.0.0.0/0"
    },
    {
      icmp_options {
        "type" = 3
        "code" = 4
      }

      protocol = 1
      source   = "0.0.0.0/0"
    },
    {
      icmp_options {
        "type" = 8
      }

      protocol = 1
      source   = "0.0.0.0/0"
    },
    {
      tcp_options {
        "max" = 80
        "min" = 80
      }

      protocol = "6"
      source   = "0.0.0.0/0"
    },
    {
      tcp_options {
        "max" = 443
        "min" = 443
      }

      protocol = "6"
      source   = "0.0.0.0/0"
    },
  ]
}

resource "oci_core_security_list" "sl1-fra" {
  provider       = "oci.fra"
  display_name   = "sl1-fra"
  compartment_id = "${var.compartment_ocid}"
  vcn_id         = "${oci_core_virtual_network.vcn-fra.id}"

  egress_security_rules = [{
    protocol    = "all"
    destination = "0.0.0.0/0"
  }]

  ingress_security_rules = [{
    tcp_options {
      "max" = 22
      "min" = 22
    }

    protocol = "6"
    source   = "0.0.0.0/0"
  },
    {
      icmp_options {
        "type" = 0
      }

      protocol = 1
      source   = "0.0.0.0/0"
    },
    {
      icmp_options {
        "type" = 3
        "code" = 4
      }

      protocol = 1
      source   = "0.0.0.0/0"
    },
    {
      icmp_options {
        "type" = 8
      }

      protocol = 1
      source   = "0.0.0.0/0"
    },
    {
      tcp_options {
        "max" = 80
        "min" = 80
      }

      protocol = "6"
      source   = "0.0.0.0/0"
    },
    {
      tcp_options {
        "max" = 443
        "min" = 443
      }

      protocol = "6"
      source   = "0.0.0.0/0"
    },
  ]
}


#### Subnet  #######

resource "oci_core_subnet" "subnet1-ash" {
  provider            = "oci.ash"
  availability_domain = "${lookup(data.oci_identity_availability_domains.ashburn.availability_domains[0],"name")}"
  cidr_block          = "${var.subnet_cidr_block}"
  display_name        = "subnet1-ash"
  dns_label           = "${var.dns_label_subnet}"
  security_list_ids   = ["${oci_core_security_list.sl1-ash.id}"]
  compartment_id      = "${var.compartment_ocid}"
  vcn_id              = "${oci_core_virtual_network.vcn-ash.id}"
  route_table_id      = "${oci_core_route_table.rt1-ash.id}"
  dhcp_options_id     = "${oci_core_virtual_network.vcn-ash.default_dhcp_options_id}"

  provisioner "local-exec" {
    command = "sleep 5"
  }
}

resource "oci_core_subnet" "subnet1-fra" {
  provider            = "oci.fra"
  availability_domain = "${lookup(data.oci_identity_availability_domains.frankfurt.availability_domains[0],"name")}"
  cidr_block          = "${var.subnet_cidr_block}"
  display_name        = "subnet1-fra"
  dns_label           = "${var.dns_label_subnet}"
  security_list_ids   = ["${oci_core_security_list.sl1-fra.id}"]
  compartment_id      = "${var.compartment_ocid}"
  vcn_id              = "${oci_core_virtual_network.vcn-fra.id}"
  route_table_id      = "${oci_core_route_table.rt1-fra.id}"
  dhcp_options_id     = "${oci_core_virtual_network.vcn-fra.default_dhcp_options_id}"

  provisioner "local-exec" {
    command = "sleep 5"
  }
}

