provider "vsphere" {
    version = "1.22.0"
    user           = var.vsphere-user
    password       = var.vsphere-password
    vsphere_server = var.vsphere-server
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
    category_id = vsphere_tag_category.tag-category.id
    description = "Manged by Terraform Cloud"
}

/***************************************************
* Create a datacenter
***************************************************/

resource "vsphere_datacenter" "modern-datacenter" {
    name = "modern-datacenter"
}

/***************************************************
* Add a host
***************************************************/

resource "vsphere_host" "esxi01" {
    hostname = var.esxi-server
    password = var.esxi-password
    username = var.esxi-user
    license = var.esxi-license
    datacenter = vsphere_datacenter.modern-datacenter.id
}
