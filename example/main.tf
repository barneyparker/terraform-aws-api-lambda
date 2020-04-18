data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "archive_file" "lambda" {
  type = "zip"
  output_path = "${path.module}/lambda.zip"
  source {
    filename = "index.js"
    content = <<-EOF
      module.exports.handler = async (event, context, callback) => {
        const response = {
          statusCode: 200,
          body: JSON.stringify({
            message: 'Hello from API Gateway!',
            details: event,
          }),
        }

        return response
      }
    EOF
  }
}

resource "aws_iam_role" "lambda" {
  name = "example_lambda_role"
  assume_role_policy = <<-EOF
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Effect": "Allow",
          "Action": "sts:AssumeRole",
          "Principal": {
            "Service": "lambda.amazonaws.com"
          }
        }
      ]
    }
  EOF
}

resource "aws_lambda_function" "lambda" {
  function_name = "example_lambda"
  filename = data.archive_file.lambda.output_path
  source_code_hash = data.archive_file.lambda.output_base64sha256

  runtime = "nodejs12.x"
  handler = "index.handler"

  role = aws_iam_role.lambda.arn
}

resource "aws_lambda_permission" "lambda_permission" {
  statement_id  = "APIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.api.id}/*/GET/"
}

resource "aws_api_gateway_rest_api" "api" {
  name = "api_lambda"
}

module "api-lambda" {
  source  = "barneyparker/api-lambda/aws"

  api_id      = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_rest_api.api.root_resource_id

  http_method = "GET"

  invoke_arn  = aws_lambda_function.lambda.invoke_arn
}