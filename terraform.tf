terraform {
  required_providers {
    docker     = "~> 5.0"
    postgresql = "~> 1.3"
    null       = "~> 2.1"
    template   = "~> 2.1"
    random     = "~> 2.1"
  }

  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "smartatransit"

    workspaces {
      name = "cloud-config"
    }
  }
}

data "terraform_remote_state" "cloud-config" {
  backend = "remote"

  config = {
    organization = "smartatransit"
    workspaces = {
      name = "cloud-config"
    }
  }
}

locals {
  cloud-config = data.terraform_remote_state.cloud-config.outputs
}

provider "docker" {
  host          = local.cloud-config.docker_connection_options.host
  ca_material   = local.cloud-config.docker_connection_options.ca_material
  cert_material = local.cloud-config.docker_connection_options.cert_material
  key_material  = local.cloud-config.docker_connection_options.key_material
}

provider "postgresql" {
  host            = local.cloud-config.postgres_connection_options.host
  username        = local.cloud-config.postgres_connection_options.username
  password        = local.cloud-config.postgres_connection_options.password
  sslmode         = local.cloud-config.postgres_connection_options.sslmode
  connect_timeout = local.cloud-config.postgres_connection_options.connect_timeout
}
