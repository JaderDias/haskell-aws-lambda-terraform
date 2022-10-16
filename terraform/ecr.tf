resource "aws_ecr_repository" "repo" {
  name = "my-haskell-lambda-image/runner"
}

resource "aws_ecr_lifecycle_policy" "repo-policy" {
  repository = aws_ecr_repository.repo.name

  policy = <<EOF
{
  "rules": [
    {
      "rulePriority": 1,
      "description": "Keep image deployed with tag latest",
      "selection": {
        "tagStatus": "tagged",
        "tagPrefixList": ["latest"],
        "countType": "imageCountMoreThan",
        "countNumber": 1
      },
      "action": {
        "type": "expire"
      }
    },
    {
      "rulePriority": 2,
      "description": "Keep last 2 any images",
      "selection": {
        "tagStatus": "any",
        "countType": "imageCountMoreThan",
        "countNumber": 2
      },
      "action": {
        "type": "expire"
      }
    }
  ]
}
EOF
}

data "aws_caller_identity" "current" {}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

// example -> ./push_docker_image.sh . 123456789012.dkr.ecr.us-west-1.amazonaws.com/hello-world latest
resource "null_resource" "push_docker_image" {
  provisioner "local-exec" {
    command     = "./push_docker_image.sh ${aws_ecr_repository.repo.repository_url} latest ${data.aws_caller_identity.current.account_id}"
    interpreter = ["bash", "-c"]
  }
}
