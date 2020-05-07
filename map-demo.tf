variable "marta_api_key" {
  type = string
}

module "map-demo" {
  source = "./modules/service"

  name  = "map-demo.staging"
  image = "smartatransit/map-demo:latest"
  port  = 4000

  env = {
    API_KEY = var.marta_api_key
  }

  traefik_network_name = local.cloud-config.traefik_network.name
}
