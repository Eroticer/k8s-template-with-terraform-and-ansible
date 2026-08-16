terraform {
  required_providers {
    beget = {
      source = "tf.beget.com/beget/beget"
    }
  }
}
provider "beget" {
  token = var.token
}