terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
    }
  }
}

data "docker_registry_image" "open-webui" {
  name = "ghcr.io/open-webui/open-webui:main"
}

resource "docker_image" "open-webui" {
  name          = data.docker_registry_image.open-webui.name
  pull_triggers = [data.docker_registry_image.open-webui.name]
}

resource "docker_container" "open-webui" {
  name  = "open-webui"
  image = docker_image.open-webui.image_id

  env = [
    "OLLAMA_BASE_URL=http://ollama:11434"
  ]
  volumes {
    host_path      = "/var/open-webui"
    container_path = "/app/backend/data"
  }
  ports {
    external = 3000
    internal = 8080
  }
  networks_advanced {
    name = var.network_name
  }
  restart = "unless-stopped"
}
