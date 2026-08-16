data "beget_software" "ubuntu" {
	slug = "ubuntu-24-04"
}

resource "beget_ssh_key" "k8s" {
  name = "k8s-ssh-key"
  public_key = file("~/.ssh/id_ed25519.pub")
}

resource "beget_compute_instance" "master" {
	count = var.master_count

	name = "k8s-master-${count.index}"
	description = "Master node for cubernetes cluster"
	hostname = "k8s-master-${count.index}"
	region = "ru1"

	configuration = {
		cpu = 2
		ram_mb = 4096
		disk_mb = 51200
		cpu_class = "normal_cpu"
	}

	image = {
		software = {
			id = data.beget_software.ubuntu.id
		}
	}

	access = {
		ssh_keys = [beget_ssh_key.k8s.id]
	}
}

resource "beget_compute_instance" "worker" {
	count = var.worker_count

	name = "k8s-worker-${count.index}"
	description = "Worker node for Kubernetes cluster"
	hostname = "k8s-worker-${count.index}"
	region = "ru1"

	configuration = {
		cpu = 2
		ram_mb = 4 * 1024
		disk_mb = 50 * 1024
		cpu_class = "normal_cpu"
	}

	image = {
		software = {
			id = data.beget_software.ubuntu.id
		}
	}

	access = {
		ssh_keys = [beget_ssh_key.k8s.id]
	}
}