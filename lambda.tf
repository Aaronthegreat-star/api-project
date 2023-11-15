resource "aws_lambda_function" "create" {
function_name = "create-request"
s3_key = "v2.0.0/create-function.zip"
runtime = "python3.10"
handler = "create-function.lambda_handler"
role = aws_iam_role.lambda_execution.arn
s3_bucket = var.s3_bucket_name
}

resource "aws_lambda_function" "delete" {
function_name = "delete-request"
s3_key = "v2.0.0/delete-function.zip"
runtime = "python3.10"
handler = "delete-function.lambda_handler"
role = aws_iam_role.lambda_execution.arn
s3_bucket = var.s3_bucket_name
}

resource "aws_lambda_function" "read" {
function_name = "read-request"
s3_key = "v2.0.0/read-function.zip"
runtime = "python3.10"
handler = "read-function.lambda_handler"
role = aws_iam_role.lambda_execution.arn
s3_bucket = var.s3_bucket_name
}

resource "aws_lambda_function" "update" {
function_name = "update-request"
s3_key = "v2.0.0/update-function.zip"
runtime = "python3.10"
handler = "update-function.lambda_handler"
role = aws_iam_role.lambda_execution.arn
s3_bucket = var.s3_bucket_name
}



resource "aws_iam_role" "lambda_execution" {
  name = "crud-api-execution"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}
resource "aws_iam_role_policy" "lambda_exec_policy" {
  name = "crud-api-execution-role-policy"
  role = aws_iam_role.lambda_execution.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "dynamodb:*",
            "Effect": "Allow",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "logs:CreateLogGroup",
            "Resource": "arn:aws:logs:us-east-1:839399074955:*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": [
                "arn:aws:logs:us-east-1:839399074955:log-group:/aws/lambda/*:*"
            ]
        }        
      ]  
}  
EOF
}
resource "aws_lambda_permission" "apigw_create_permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.create.function_name
  principal     = "apigateway.amazonaws.com" 
  source_arn = "${aws_apigatewayv2_api.crud_api_http_api_gw.execution_arn}/*/POST/items"
}

resource "aws_lambda_permission" "apigw_delete_permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.delete.function_name
  principal     = "apigateway.amazonaws.com" 
  source_arn = "${aws_apigatewayv2_api.crud_api_http_api_gw.execution_arn}/*/DELETE/items"
}

resource "aws_lambda_permission" "apigw_read_all_permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.read.function_name
  principal     = "apigateway.amazonaws.com" 
  source_arn = "${aws_apigatewayv2_api.crud_api_http_api_gw.execution_arn}/*/GET/items"
}

resource "aws_lambda_permission" "apigw_read_item_permission" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.read.function_name
  principal     = "apigateway.amazonaws.com" 
  source_arn = "${aws_apigatewayv2_api.crud_api_http_api_gw.execution_arn}/*/GET/items{id}"
}

resource "aws_lambda_permission" "apigw_update_permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.update.function_name
  principal     = "apigateway.amazonaws.com" 
  source_arn ="${aws_apigatewayv2_api.crud_api_http_api_gw.execution_arn}/*/PUT/items"
}


