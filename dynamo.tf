resource "aws_dynamodb_table" "api_dynamo_table" {
  name           = "my-crud-table"
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5
  hash_key = "id"
  attribute {
    name = "id"
    type = "S"
  }
}