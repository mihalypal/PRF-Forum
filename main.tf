terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.0"
    }
  }
}

provider "docker" {}

# MongoDB container
resource "docker_image" "mongodb_image" {
  name = "my_mongo_image"
  build {
    context    = "./backend"
    dockerfile = "Dockerfile"
  }
}

resource "docker_container" "mongodb_container" {
  image = docker_image.mongodb_image.name
  name  = "my_mongo_container"
  ports {
    internal = 27017
    external = 5000
  }
  restart = "always"
}

# Backend container
resource "docker_image" "backend_image" {
  name = "backend-app"
  build {
    context    = "./backend"
    dockerfile = "Dockerfile_be"
  }
}

resource "docker_container" "backend_container" {
  image = docker_image.backend_image.name
  name  = "backend_container"
  ports {
    internal = 3000
    external = 3000
  }
  restart = "always"
  depends_on = [docker_container.mongodb_container]
  env = {
    MONGO_URL = "mongodb://my_mongo_container:27017/my_db"
  }
}

# Frontend container
resource "docker_image" "frontend_image" {
  name = "frontend-app"
  build {
    context    = "./frontend"
  }
}

resource "docker_container" "frontend_container" {
  image = docker_image.frontend_image.name
  name  = "frontend_container"
  ports {
    internal = 4200
    external = 4200
  }
  restart = "always"
  depends_on = [docker_container.backend_container]
}