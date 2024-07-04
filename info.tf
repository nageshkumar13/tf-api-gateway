
#Method request 
resource "aws_api_gateway_method" "proxy2" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.root2.id
  http_method = "GET"
  authorization = "NONE"
}

# Integration request 
resource "aws_api_gateway_integration" "lambda_integration2" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.root2.id
  http_method = aws_api_gateway_method.proxy2.http_method
  integration_http_method = "POST"
  type = "AWS_PROXY"
  uri = aws_lambda_function.html_lambda.invoke_arn
}

#Intergration response
resource "aws_api_gateway_integration_response" "proxy2" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.root2.id
  http_method = aws_api_gateway_method.proxy2.http_method
  status_code = aws_api_gateway_method_response.proxy2.status_code

  //cors
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" =  "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT'",
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
}
  depends_on = [
    aws_api_gateway_method.proxy2,
    aws_api_gateway_integration.lambda_integration
  ]
}

#Method response 
resource "aws_api_gateway_method_response" "proxy2" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.root2.id
  http_method = aws_api_gateway_method.proxy2.http_method
  status_code = "200"
  
  //cors section
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}

## ## ## ## ## ## ##   //options ## ## ## ## ## ## ## ## for users

resource "aws_api_gateway_method" "options2" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.root2.id
  http_method = "OPTIONS"
  authorization = "NONE"
  #
  #authorization = "COGNITO_USER_POOLS"
  #authorizer_id = aws_api_gateway_authorizer.demo.id
}

resource "aws_api_gateway_integration" "options_integration2" {
  rest_api_id             = aws_api_gateway_rest_api.my_api.id
  resource_id             = aws_api_gateway_resource.root2.id
  http_method             = aws_api_gateway_method.options2.http_method
  type                    = "MOCK"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

resource "aws_api_gateway_method_response" "options_response2" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.root2.id
  http_method = aws_api_gateway_method.options2.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

resource "aws_api_gateway_integration_response" "options_integration_response2" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.root2.id
  http_method = aws_api_gateway_method.options2.http_method
  status_code = aws_api_gateway_method_response.options_response2.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT'",
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }

  depends_on = [
    aws_api_gateway_method.options2,
    aws_api_gateway_integration.options_integration2,
  ]
}




