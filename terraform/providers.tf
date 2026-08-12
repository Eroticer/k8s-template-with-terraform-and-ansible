terraform {
  required_providers {
    beget = {
      source = "tf.beget.com/beget/beget"
    }
  }
}
provider "beget" {
  api_token = var.api_token
}