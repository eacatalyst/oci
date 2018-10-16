###### Create Groups ######

resource "oci_identity_group" "groups" {
  count       = "${var.count}"
  name        = "${format("EdgeLabGroup-%1d", count.index)}"
  description = "${format("EdgeLabGroup-%1d", count.index)}"
}

##### Create Users and Passwords #######

resource "oci_identity_user" "users" {
  count       = "${var.count}"
  name        = "${format("edgelabuser-%1d", count.index)}"
  description = "${format("edgelabuser-%1d", count.index)}"
}

resource "oci_identity_ui_password" "user_pwd" {
  count   = "${var.count}"
  user_id = "${element(oci_identity_user.users.*.id, count.index)}"
}

##### Add Users to Groups ############

resource "oci_identity_user_group_membership" "group_membership" {
  depends_on = ["oci_identity_user.users", "oci_identity_group.groups"]
  count      = "${var.count}"
  user_id    = "${element(oci_identity_user.users.*.id, count.index)}"
  group_id   = "${element(oci_identity_group.groups.*.id, count.index)}"
}

##### Create Compartments ##########
##
##resource "oci_identity_compartment" "compartments" {
###  count       = "${var.count}"
##  name        = "${format("SB1-Compartment%1d", count.index)}"
##  description = "Compartment for user ${format("SB1-User%1d", count.index)}"
##}

##### Create Policies #######

resource "oci_identity_policy" "policies" {
  depends_on     = ["oci_identity_user.users", "oci_identity_group.groups", "oci_identity_user_group_membership.group_membership"]
  count          = "${var.count}"
  name           = "${format("PolicyForedgelabUser%1d", count.index)}"
  description    = "${format("Policy For dgelabUserUser%1d", count.index)}"
  compartment_id = "${var.tenancy_ocid}"
  #statements     = ["${format("Allow group EdgeLabGroup-%1d", count.index)} to manage dns in compartment ${format("EdgeLab-%1d", count.index)}"]
   statements     = ["${format("Allow group EdgeLabGroup-%1d", count.index)} to manage all-resources in compartment EdgeLab-0"]
}

###### Display Temp Passwords for each User ########

output "users_temp_credentials" {
  sensitive = false
  value     = "${formatlist("User: %v   Password: %v", oci_identity_user.users.*.name, oci_identity_ui_password.user_pwd.*.password)}"
}
