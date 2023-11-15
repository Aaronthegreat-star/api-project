resource "aws_apigatewayv2_api" "crud_api_http_api_gw" {
  name          = "crud-http-api_gw"
  protocol_type = "HTTP"
}
resource "aws_apigatewayv2_integration" "create_api_integration" {
  api_id           = aws_apigatewayv2_api.crud_api_http_api_gw.id
  integration_type = "AWS_PROXY"
  connection_type           = "INTERNET"
  description               = "create"
  integration_method        = "POST"
  integration_uri           = aws_lambda_function.create.invoke_arn
  payload_format_version = "2.0"
  passthrough_behavior      = "WHEN_NO_MATCH"
}
resource "aws_apigatewayv2_route" "create_api_route" {
  api_id    = aws_apigatewayv2_api.crud_api_http_api_gw.id
  route_key = "POST /items"

  target = "integrations/${aws_apigatewayv2_integration.create_api_integration.id}"
}
resource "aws_apigatewayv2_integration" "read_api_integration" {
  api_id           = aws_apigatewayv2_api.crud_api_http_api_gw.id
  integration_type = "AWS_PROXY"
  connection_type           = "INTERNET"
  description               = "read"
  integration_method        = "POST"
  integration_uri           = aws_lambda_function.read.invoke_arn
  payload_format_version = "2.0"
  passthrough_behavior      = "WHEN_NO_MATCH"
}
resource "aws_apigatewayv2_route" "read_item_api_route" {
  api_id    = aws_apigatewayv2_api.crud_api_http_api_gw.id
  route_key = "GET /items/{id}"

  target = "integrations/${aws_apigatewayv2_integration.read_api_integration.id}"
}
resource "aws_apigatewayv2_route" "read_all_api_route" {
  api_id    = aws_apigatewayv2_api.crud_api_http_api_gw.id
  route_key = "GET /items"

  target = "integrations/${aws_apigatewayv2_integration.read_api_integration.id}"
}
resource "aws_apigatewayv2_integration" "update_api_integration" {
  api_id           = aws_apigatewayv2_api.crud_api_http_api_gw.id
  integration_type = "AWS_PROXY"
  connection_type           = "INTERNET"
  description               = "update"
  integration_method        = "POST"
  integration_uri           = aws_lambda_function.update.invoke_arn
  payload_format_version = "2.0"
  passthrough_behavior      = "WHEN_NO_MATCH"
}
resource "aws_apigatewayv2_route" "update_item_api_route" {
  api_id    = aws_apigatewayv2_api.crud_api_http_api_gw.id
  route_key = "PUT /items/{id}"

  target = "integrations/${aws_apigatewayv2_integration.update_api_integration.id}"
}
resource "aws_apigatewayv2_integration" "delete_api_integration" {
  api_id           = aws_apigatewayv2_api.crud_api_http_api_gw.id
  integration_type = "AWS_PROXY"
  connection_type           = "INTERNET"
  description               = "delete"
  integration_method        = "POST"
  integration_uri           = aws_lambda_function.delete.invoke_arn
  payload_format_version = "2.0"
  passthrough_behavior      = "WHEN_NO_MATCH"
}
resource "aws_apigatewayv2_route" "delete_item_api_route" {
  api_id    = aws_apigatewayv2_api.crud_api_http_api_gw.id
  route_key = "DELETE /items/{id}"//correct the value

  target = "integrations/${aws_apigatewayv2_integration.delete_api_integration.id}"
}
resource "aws_apigatewayv2_stage" "crud_api_deployment_stage" {
  api_id = aws_apigatewayv2_api.crud_api_http_api_gw.id
  name   = "$default"
  auto_deploy = true
}
output "api_gateway_endpoint" {
    value = aws_apigatewayv2_api.crud_api_http_api_gw.api_endpoint
    description = "returns api endpoint with this address"
}
