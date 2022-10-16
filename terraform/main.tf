terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.27.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

resource "random_pet" "deployment" {
  length = 2
}

variable "prefix" {
  description = "prefix prepended to names of all resources created"
  default     = "my-haskell-lambda"
}

module "s3update_function" {
  source         = "./modules/function"
  function_name  = "${terraform.workspace}_s3update_${random_pet.deployment.id}"
  image_uri      = "${aws_ecr_repository.repo.repository_url}:latest"
  lambda_handler = "handler"
  tags = {
    environment   = terraform.workspace
    deployment_id = random_pet.deployment.id
  }

  depends_on = [
    null_resource.push_docker_image
  ]
}

