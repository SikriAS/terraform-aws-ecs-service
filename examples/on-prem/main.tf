provider "aws" {
  region = "eu-west-1"
}

locals {
  name_prefix = "infrademo"
  application_name = "my-webapp"
}

/*
 * = Various required resources
 */

data "aws_ecs_cluster" "main" {
  cluster_name = "${local.name_prefix}-cluster"
}

/*
 * = The actual setup
 */

module "service" {
  source = "../../"

  name_prefix = local.application_name

  cluster_id = data.aws_ecs_cluster.main.id

  # This indicates that we are launching to ECS Anywhere
  launch_type = "EXTERNAL"

  application_container = {
    name = "main"
    image = "nginx:latest"
    port = 80
    protocol = "HTTP"
  }
}
