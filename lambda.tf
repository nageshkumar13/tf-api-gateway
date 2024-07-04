data "archive_file" "lambda_package" {
  type = "zip"
  source_file = "index.py"
  output_path = "index.zip"
}

resource "aws_lambda_function" "html_lambda" {
  filename = "index.zip"
  function_name = "myLambdaFunction"
  role = aws_iam_role.lambda_role.arn
  handler = "index.lambda_handler"
  runtime = "python3.8"
  source_code_hash = data.archive_file.lambda_package.output_base64sha256
}