resource "aws_lambda_function" "myfunc" {
  function_name = var.function_name
  image_uri     = var.image_uri
  package_type  = "Image"
  role          = aws_iam_role.iam_for_terraform_lambda.arn
  tags          = var.tags
  timeout       = 540

  # Explicitly declare dependency on EFS mount target.
  # When creating or updating Lambda functions, mount target must be in 'available' lifecycle state.
  depends_on = [
    aws_cloudwatch_log_group.lambda_log_group,
  ]
}
