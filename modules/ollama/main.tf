terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
    }
  }
}

data "docker_registry_image" "ollama" {
  name = "ollama/ollama:latest"
  #name = "ollama/ollama:rocm"
}

resource "docker_image" "ollama" {
  name          = data.docker_registry_image.ollama.name
  pull_triggers = [data.docker_registry_image.ollama.name]
}

#docker run -d --restart always --device /dev/kfd --device /dev/dri -v ollama:/root/.ollama -p 11434:11434 --name ollama ollama/ollama:rocm
#docker run -d --restart always --device /dev/kfd --device /dev/dri -v ollama:/root/.ollama -p 11434:11434 --name ollama -e HSA_OVERRIDE_GFX_VERSION=10.3.0 -e HCC_AMDGPU_TARGET=gfx1030 ollama/ollama:rocm
resource "docker_container" "ollama" {
  name  = "ollama"
  image = docker_image.ollama.image_id
  devices {
    host_path = "/dev/kfd"
  }
  devices {
    host_path = "/dev/dri"
  }
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
