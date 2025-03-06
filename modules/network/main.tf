terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
}

resource "docker_network" "main-network" {
  name   = "main-network"
  driver = "bridge"
}
