data "beget_image" "ubuntu" {
	name = "Ubuntu 22.04 LTS"
}

resource "beget_ssh_key" "k8s_key" {
  name = "k8s-ssh-key"
  public_key = file("~/.ssh/id_ed25519.pub")
}

resource "beget_compute_instance" "master" {
	count = var.master_count
	name = "k8s-master-${count.index}"
	description = "Master node for cubernetes cluster"
	hostname = "k8s-master-${count.index}"
	region = "ru1"
	image_id = data.beget_image.ubuntu.id
	ssh_key_ids = [beget_ssh_key.k8s_key_id]

	configuration = {
		cpu = 2
		ram_mb = 4 * 1024
		disk_mb = 50 * 1024
		cpu_class = "normal_cpu"
	}

	labels = {
		role = "master"
		cluster = "k8s"
		env = "production"
		managed_by = "terraform"
	}
}

resource "beget_compute_instance" "worker" {
	count = var.worker_count
	name = "k8s-worker-${count.index}"
	description = "Worker node for Kubernetes cluster"
	hostname = "k8s-worker-${count.index}"
	region = "ru1"
	image_id = data.beget_image.ubuntu.id
	ssh_keys = [beget_ssh_key.k8s_key_id]

	configuration = {
		cpu = 2
		ram_mb = 4 * 1024
		disk_mb = 50 * 1024
		cpu_class = "normal_cpu"
	}

	labels = {
		role = "worker"
		cluser = "k8s"
		env = "production"
		manage_by = "terraform"
	}
}