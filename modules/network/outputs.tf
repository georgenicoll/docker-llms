output "docker_network_name" {
    description = "The name of the docker network"
    value = docker_network.the_network.name
}