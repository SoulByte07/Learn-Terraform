output "api_endpoint" {
  description = "Base URL of the API Gateway HTTP API"
  value = var.use_localstack
    ? "http://${aws_apigatewayv2_api.this.id}.execute-api.localhost.localstack.cloud:4566"
    : aws_apigatewayv2_api.this.api_endpoint
}

output "api_id" {
  description = "ID of the API Gateway HTTP API"
  value       = aws_apigatewayv2_api.this.id
}

output "function_name" {
  description = "Name of the Lambda function"
  value       = aws_lambda_function.this.function_name
}

output "function_arn" {
  description = "ARN of the Lambda function"
  value       = aws_lambda_function.this.arn
}

output "execution_role_arn" {
  description = "ARN of the Lambda execution role"
  value       = aws_iam_role.lambda_exec.arn
}
