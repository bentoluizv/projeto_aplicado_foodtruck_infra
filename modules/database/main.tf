terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
}

resource "docker_image" "database" {
  name         = "postgres:17.4"
  keep_locally = false
}

resource "docker_volume" "pg_data" {
  name = "pg_data"
}

resource "docker_container" "database" {
  name  = "database"
  image = docker_image.database.image_id
  ports {
    internal = 5432
    external = 5432
    ip       = "0.0.0.0"
    protocol = "tcp"
  }
  env = [
    "POSTGRES_USER=${var.username}",
    "POSTGRES_PASSWORD=${var.password}",
    "POSTGRES_DB=${var.database_name}",
    "PGDATA=/var/lib/postgresql/data/pgdata"
  ]
  networks_advanced {
    name = var.network_id
  }
  volumes {
    volume_name    = docker_volume.pg_data.name
    container_path = "/var/lib/postgresql/data"
  }
  healthcheck {
    test     = ["CMD-SHELL", "pg_isready -U ${var.username} -d ${var.database_name}"]
    interval = "10s"
    timeout  = "5s"
    retries  = 5
  }
  restart = "always"
  command = [
    "postgres",
    "-c", "shared_buffers=512MB",
    "-c", "max_connections=200",
    "-c", "work_mem=32MB"
  ]
}
