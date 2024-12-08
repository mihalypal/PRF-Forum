provider "docker" {}

resource "docker_image" "docker_compose_image" {
  name = "docker/compose:latest"
}

resource "docker_container" "docker_compose" {
  image = docker_image.docker_compose_image.name
  name  = "docker_compose_runner"
  volumes {
    host_path      = "${path.module}/docker-compose.yml" # Path relative to the main.tf
    container_path = "/docker-compose.yml"
  }
  command = ["docker-compose", "-f", "/docker-compose.yml", "up", "--build", "-d"]
}
