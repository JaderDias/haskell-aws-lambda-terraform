data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    effect = "Allow"
  }
}

# Lambda function role
resource "aws_iam_role" "iam_for_terraform_lambda" {
  name               = "${var.function_name}-lambda-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
  tags = {
    environment = terraform.workspace
  }
}

data "aws_iam_policy" "AWSLambdaExecute" {
  arn = "arn:aws:iam::aws:policy/AWSLambdaExecute"
}

resource "aws_iam_role_policy_attachment" "AWSLambdaExecute-attach" {
  role       = aws_iam_role.iam_for_terraform_lambda.id
  policy_arn = data.aws_iam_policy.AWSLambdaExecute.arn
}

data "aws_iam_policy" "AmazonAthenaFullAccess" {
  arn = "arn:aws:iam::aws:policy/AmazonAthenaFullAccess"
}

resource "aws_iam_role_policy_attachment" "AmazonAthenaFullAccess-attach" {
  role       = aws_iam_role.iam_for_terraform_lambda.id
  policy_arn = data.aws_iam_policy.AmazonAthenaFullAccess.arn
}