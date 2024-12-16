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
  env = [
    "MONGO_URL=mongodb://my_mongo_container:27017/my_db"
  ]
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

# Nginx Image
resource "docker_image" "nginx_image" {
  name = "nginx-reverse-proxy"
  build {
    context    = "."  # A projekt gyökérmappa a build kontextus
    dockerfile = "nginx/Dockerfile"
  }
}

# Nginx Container
resource "docker_container" "nginx_container" {
  image = docker_image.nginx_image.name
  name  = "nginx_container"
  ports {
    internal = 80
    external = 80
  }
  restart = "always"
  depends_on = [docker_container.frontend_container]
}

# Prometheus
# resource "docker_image" "prometheus_image" {
#   name = "prom/prometheus:latest"
# }

# resource "docker_container" "prometheus_container" {
#   image = docker_image.prometheus_image.name
#   name  = "prometheus_container"
#   ports {
#     internal = 9090
#     external = 9090
#   }
#   restart = "always"
#   volumes {
#     host_path = "${abspath(path.module)}/prometheus.yml"
#     container_path = "/etc/prometheus/prometheus.yml"
#   }
# }

# Prometheus modul
module "prometheus" {
  source = "./modules/prometheus"

  depends_on = [docker_container.backend_container]
}

# Grafana
# resource "docker_image" "grafana_image" {
#   name = "grafana/grafana:latest"
# }
# 
# resource "docker_container" "grafana_container" {
#   image = docker_image.grafana_image.name
#   name  = "grafana_container"
#   ports {
#     internal = 3000
#     external = 3100 # Mert a backend már foglalja a 3000-et
#   }
#   restart = "always"
#   depends_on = [module.prometheus.prometheus_container]
# }

# Grafana modul
module "grafana" {
  source = "./modules/grafana"
  
  prometheus_url = "http://91.214.112.223:9090"
  depends_on = [module.prometheus.prometheus_container]
}