
#Method request 
resource "aws_api_gateway_method" "update" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.update.id
  http_method = "PUT"
  authorization = "NONE"
}

# Integration request 
resource "aws_api_gateway_integration" "lambda_integration3" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.update.id
  http_method = aws_api_gateway_method.update.http_method
  integration_http_method = "POST"
  type = "AWS_PROXY"
  uri = aws_lambda_function.html_lambda.invoke_arn
}

#Intergration response
resource "aws_api_gateway_integration_response" "update" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.update.id
  http_method = aws_api_gateway_method.update.http_method
  status_code = aws_api_gateway_method_response.update.status_code

  //cors
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" =  "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS_3,POST,PUT'",
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
}
  depends_on = [
    aws_api_gateway_method.update,
    aws_api_gateway_integration.lambda_integration3
  ]
}

#Method response 
resource "aws_api_gateway_method_response" "update" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.update.id
  http_method = aws_api_gateway_method.update.http_method
  status_code = "200"
  
  //cors section
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}

## ## ## ## ## ## ##   //options_3 ## ## ## ## ## ## ## ## for users

resource "aws_api_gateway_method" "options_3" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.update.id
  http_method = "OPTIONS"
  authorization = "NONE"
  #
  #authorization = "COGNITO_USER_POOLS"
  #authorizer_id = aws_api_gateway_authorizer.demo.id
}

resource "aws_api_gateway_integration" "options_3_integration" {
  rest_api_id             = aws_api_gateway_rest_api.my_api.id
  resource_id             = aws_api_gateway_resource.update.id
  http_method             = aws_api_gateway_method.options_3.http_method
  type                    = "MOCK"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

resource "aws_api_gateway_method_response" "options_3_response" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.update.id
  http_method = aws_api_gateway_method.options_3.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

resource "aws_api_gateway_integration_response" "options_3_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.update.id
  http_method = aws_api_gateway_method.options_3.http_method
  status_code = aws_api_gateway_method_response.options_3_response.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS_3,POST,PUT'",
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }

  depends_on = [
    aws_api_gateway_method.options_3,
    aws_api_gateway_integration.options_3_integration,
  ]
}




