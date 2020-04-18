# terraform-aws-api-lambda

Module to simplify attaching Lambda handlers to API Gateway routes.

## Compatibility

This modules is HCL2 compatible only.

## Example

See example dir for full code:

```
module "api-lambda" {
  source  = "barneyparker/api-lambda/aws"

  api_id      = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_rest_api.api.root_resource_id

  http_method = "GET"

  invoke_arn  = aws_lambda_function.lambda.invoke_arn
}
```
