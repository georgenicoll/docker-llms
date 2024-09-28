terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
    }
  }
}

data "docker_registry_image" "watchtower" {
  name = "containrrr/watchtower:latest"
}

resource "docker_image" "watchtower" {
  name          = data.docker_registry_image.watchtower.name
  pull_triggers = [data.docker_registry_image.watchtower.name]
}

resource "docker_container" "watchtower" {
  name  = "watchtower"
  image = docker_image.watchtower.image_id
  volumes {
    host_path      = "/var/run/docker.sock"
    container_path = "/var/run/docker.sock"
  }
  restart = "unless-stopped"
}
