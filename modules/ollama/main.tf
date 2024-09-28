terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
    }
  }
}

data "docker_registry_image" "ollama" {
  name = "ollama/ollama:latest"
}

resource "docker_image" "ollama" {
  name          = data.docker_registry_image.ollama.name
  pull_triggers = [data.docker_registry_image.ollama.name]
}

resource "docker_container" "ollama" {
  name  = "ollama"
  image = docker_image.ollama.image_id
  volumes {
    host_path      = "/var/ollama"
    container_path = "/root/.ollama"
  }
  ports {
    external = 11434
    internal = 11434
  }
  networks_advanced {
    name = var.network_name
  }
  restart = "unless-stopped"
}
