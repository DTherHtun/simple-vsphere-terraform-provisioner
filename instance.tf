data "vsphere_datacenter" "dc" {
    name = "${var.datacenter}"
}

data "vsphere_compute_cluster" "cluster" {
    name = "${var.cluster}"
    datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_datastore" "datastore" {
    name = "${var.datastore}"
    datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_network" "network" {
    name = "${var.portgroup}"
    datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_virtual_machine" "template" {
    name = "${var.template}"
    datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

resource "vsphere_folder" "vm-folder" {
  path          = "${var.vmfolder}"
  type          = "vm"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

resource "vsphere_virtual_machine" "myvm" {
    count               = "${var.numberofhost}"
    name                = "${var.vmname}${count.index + 1}"
    num_cpus            = "${var.vmcpus}"
    memory              = "${var.vmmems}"
    folder              = "${vsphere_folder.vm-folder.path}"
    datastore_id        = "${data.vsphere_datastore.datastore.id}"
    resource_pool_id    = "${data.vsphere_compute_cluster.cluster.resource_pool_id}"
    datastore_id        = "${data.vsphere_datastore.datastore.id}"
    guest_id            = "${data.vsphere_virtual_machine.template.guest_id}"
    network_interface {
        network_id      = "${data.vsphere_network.network.id}"
        adapter_type    = "${data.vsphere_virtual_machine.template.network_interface_types[0]}"
    }
    disk {
        label            = "${var.vmname}${count.index + 1}.vmdk"
        thin_provisioned = "${data.vsphere_virtual_machine.template.disks.0.thin_provisioned}"
        size             = "${var.vmdisk01}"
	unit_number      = 0
    }
    disk {
        label            = "${var.vmname}${count.index + 2}.vmdk"
        thin_provisioned = "${data.vsphere_virtual_machine.template.disks.0.thin_provisioned}"
        size             = "${var.vmdisk02}"
	unit_number      = 1
    }
    clone {
        template_uuid   = "${data.vsphere_virtual_machine.template.id}"

        customize {
            linux_options {
                host_name   = "mm1p-ansible0${count.index + 1}"
                domain      = "${var.vmdomain}"
            }
            network_interface {
                ipv4_address    = "${var.ipaddr}${2 + count.index}"
                ipv4_netmask    = "${var.ipnetmask}"
            }
            ipv4_gateway    = "${var.ipgw}"
            dns_server_list = [ "${var.ipdns}" ]
        }
    }
    connection {
  	type		= "ssh"
	user		= "${var.sshuser}"
	password	= "${var.sshpasswd}"
    }
    provisioner "file" {
	source		= "lvextend.sh"
	destination	= "/tmp/lvextend.sh"
    }
    provisioner	"remote-exec" {
	inline		= [
			"chmod +x /tmp/lvextend.sh",
			"/tmp/lvextend.sh"
			]
    }
}
