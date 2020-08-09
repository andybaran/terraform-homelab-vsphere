provider "vsphere" {
    version = "1.22.0"
    user           = var.vsphere_user
    password       = var.vsphere_password
    vsphere_server = var.vsphere_server
    allow_unverified_ssl = true
}

/***************************************************
* Create tag so we can track TFC created resources
***************************************************/

resource "vsphere_tag_category" "tag-category" {
    name = "tfc"
    cardinality = "SINGLE"
    description = "Managed by Terraform Cloud"

    associable_types = [
        "VirtualMachine",
    ]
}

resource "vsphere_tag" "managed-by-tfc" {
    name = "managed-by-tfc"
    category_id = vsphere_tag_category.id
    description = "Manged by Terraform Cloud"
}

/***************************************************
* Create a datacenter
***************************************************/

resource "vsphere_datacenter" "modern-datacenter" {
    name = "modern-datacenter"
    tags = [managed-by-tfc.tag.id]
}

/***************************************************
* Add a host
***************************************************/

data "vsphere_datacenter" "new-dc" {
    name = var.datacenter
}

resource "vsphere_host" "esxi01" {
    hostname = var.esxi-vsphere_server
    username = var.esxi-user
    password = var.esxi-password
    license = var.esxi-license
    datacenter = data.vsphere_datacenter.new-dc.id
}
