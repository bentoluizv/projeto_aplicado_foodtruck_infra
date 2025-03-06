terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
}

provider "docker" {
  host     = "ssh://root@89.117.33.177:22"
  ssh_opts = ["-o", "StrictHostKeyChecking=no", "-o", "UserKnownHostsFile=/dev/null"]
}

module "network" {
  source = "./modules/network"
  providers = {
    docker = docker
  }

}

module "cache" {
  source     = "./modules/cache"
  network_id = module.network.network_id

  providers = {
    docker = docker
  }
}

module "database" {
  source     = "./modules/database"
  password   = var.postgres_password
  network_id = module.network.network_id
  providers = {
    docker = docker
  }
}

module "backend" {
  source       = "./modules/backend"
  database_url = var.database_url
  redis_url    = var.redis_url
  network_id   = module.network.network_id
  providers = {
    docker = docker
  }

}
