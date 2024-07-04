resource "aws_api_gateway_rest_api" "my_api" {
  name = "bigbucket"
  description = "My API Gateway"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_resource" "root" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  parent_id = aws_api_gateway_rest_api.my_api.root_resource_id
  path_part = "users"
}

resource "aws_api_gateway_resource" "root1" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  parent_id = aws_api_gateway_rest_api.my_api.root_resource_id
  path_part = "products"
}

resource "aws_api_gateway_resource" "root2" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  parent_id = aws_api_gateway_rest_api.my_api.root_resource_id
  path_part = "Info"
}

resource "aws_api_gateway_resource" "update" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  parent_id = aws_api_gateway_rest_api.my_api.root_resource_id
  path_part = "Update"
}

resource "aws_api_gateway_resource" "delete" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  parent_id = aws_api_gateway_rest_api.my_api.root_resource_id
  path_part = "delete"
}


resource "aws_api_gateway_deployment" "deployment" {
  depends_on = [
    aws_api_gateway_integration.lambda_integration,
    aws_api_gateway_integration.options_integration, # Add this line
  ]
  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_rest_api.my_api.body,
      aws_api_gateway_integration.lambda_integration2.id,
      aws_api_gateway_integration.lambda_integration2.resource_id,
      aws_api_gateway_integration.lambda_integration2.integration_http_method,
      aws_api_gateway_integration.lambda_integration3.id,
      aws_api_gateway_integration.lambda_integration3.resource_id,
      aws_api_gateway_integration.lambda_integration4.id,
      aws_api_gateway_integration.lambda_integration4.resource_id
      ]))
  }

  rest_api_id = aws_api_gateway_rest_api.my_api.id
  stage_name = "dev"
}