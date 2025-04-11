terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
}

resource "docker_image" "cache" {
  name         = "redis:latest"
  keep_locally = false
}

resource "docker_volume" "cache_data" {
  name = "cache_data"
}

resource "docker_container" "cache" {
  name  = "cache"
  image = docker_image.cache.image_id
  ports {
    internal = 6379
    ip       = "0.0.0.0"
    protocol = "tcp"
  }
  env = [
    "MAXMEMORY=512mb",
    "MAXMEMORY_POLICY=allkeys-lru"
  ]
  networks_advanced {
    name = var.network_id
  }
  volumes {
    container_path = "/data"
    volume_name    = docker_volume.cache_data.name
  }
  healthcheck {
    test     = ["CMD", "redis-cli", "ping"]
    interval = "10s"
    timeout  = "5s"
    retries  = 5
  }
  restart = "always"
}
