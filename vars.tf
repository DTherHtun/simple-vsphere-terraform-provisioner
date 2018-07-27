variable "VSPHERE_USER" {}
variable "VSPHERE_PASSWORD" {}
variable "VSPHERE_SERVER" {}
variable "ALLOW_UNVERIFIED_SSL" {}

variable "datacenter" {}
variable "cluster" {}
variable "datastore" {}
variable "portgroup" {}

variable "vmfolder" {}
variable "resourcepooldefault" {}
variable "template" {}
variable "numberofhost" {}

variable "ipdns" { type = "list" }
variable "ipaddr" {}
variable "ipnetmask" {}
variable "ipgw" {}

variable "vmname" {}
variable "vmcpus" {}
variable "vmmems" {}
variable "vmdisk01" {}
variable "vmdisk02" {}
variable "vmdomain" {}
variable "sshuser" {}
variable "sshpasswd" {}
