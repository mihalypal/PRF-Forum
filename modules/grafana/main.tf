# modules/grafana/main.tf
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.0"
    }
  }
}

resource "docker_image" "grafana" {
  name = "grafana/grafana:latest"
  force_remove = true
}

# resource "docker_image" "grafana" {
#   name = "custom-grafana:latest"
#   force_remove = true
#   build {
#     context = "."
#     dockerfile = "Dockerfile_grafana"
#     no_cache = true
#   }
# }

resource "docker_container" "grafana" {
  name  = "grafana"
  image = docker_image.grafana.image_id

  ports {
    internal = 3000
    external = 3100
  }

  env = [
    "GF_SECURITY_ADMIN_PASSWORD=${var.grafana_admin_password}",
    "GF_INSTALL_PLUGINS=grafana-clock-panel,grafana-simple-json-datasource"  # Opcionális plugin-ek
  ]

  # előző verzió
  # volumes {
  #   host_path      = "/workspace/grafana/provisioning"
  #   container_path = "/etc/grafana/provisioning"
  # }
  
  volumes {
    host_path      = "/var/jenkins_home/workspace/MEAN-Stack-Pipeline/modules/grafana/provisioning/datasources"
    container_path = "/etc/grafana/provisioning/datasources"
  }

  volumes {
    host_path      = "/var/jenkins_home/workspace/MEAN-Stack-Pipeline/modules/grafana/provisioning/dashboards"
    container_path = "/etc/grafana/provisioning/dashboards"
  }
}