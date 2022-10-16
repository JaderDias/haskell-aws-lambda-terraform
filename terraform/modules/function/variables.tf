variable "function_name" {
  type = string
}
variable "lambda_handler" {
  type = string
}
variable "image_uri" {
  type = string
}
variable "tags" {
  description = "tags for lambda function"
  type        = map(string)
}
