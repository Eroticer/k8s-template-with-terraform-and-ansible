output "master_ips" {
	value = beget_compute_instance.master[*].ip_address
}

output "worker_ips" {
  value = beget_compute_instance.worker[*].ip_address
}

output "inventory" {
	value = templatefile("${path.module}/../ansible/inventory.tpl", {
		master_ips = beget_compute_instance.master[*].ip_address
		worker_ips = beget_compute_instance.worker[*].ip_address
	})
}