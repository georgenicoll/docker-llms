terraform {
  required_providers {
    # https://search.opentofu.org/provider/kreuzwerker/docker/latest/docs/resources/image
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

module "network" {
  source = "./modules/network"
  network_name = "llms"
}

module "watchtower" {
  source = "./modules/watchtower"
}

module "ollama" {
  source = "./modules/ollama"
  network_name = module.network.docker_network_name
}

module "open-webui" {
  source = "./modules/open-webui"
  network_name = module.network.docker_network_name
}
