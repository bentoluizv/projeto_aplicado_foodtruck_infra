terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
}

resource "docker_image" "backend" {
  name         = "bentoluizv/projeto_aplicado:latest"
  keep_locally = false
}

resource "docker_container" "backend" {
  name        = "backend"
  image       = docker_image.backend.image_id
  working_dir = "/projeto_aplicado"
  command     = ["fastapi", "run", "app.py", "--host", "0.0.0.0", ]
  ports {
    internal = 8000
    external = 8000
    ip       = "0.0.0.0"
    protocol = "tcp"
  }
  env = [
    "ENV=production",
    "DEBUG=False",
    "DATABASE_URL=${var.database_url}",
    "REDIS_URL=redis://redis:6379",
  ]
  networks_advanced {
    name = var.network_id
  }

  restart = "always"
}
