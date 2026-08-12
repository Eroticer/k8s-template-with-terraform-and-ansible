variable "api_token" {
  description = "API token for Beget"
  type = string
  sensitive = true
}

variable "master_count" {
  description = "Number of master nodes"
  type = number
  default = 1
}

variable "worker_count" {
  description = "Number of worker nodes"
  type = number
  default = 2
}

variable "ssh_public_key_path" {
  description = "Path to SSH pablic key"
  type = string
  default = "~/.ssh/id_ed25519.pub"
}