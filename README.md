# terraform-aws-lambda

This Terraform module creates an AWS Lambda function

## Notes

This terraform module manages aws lambda function zip file on s3 bucket only. If you need manage with filename, please check its [upstream](https://github.com/claranet/terraform-aws-lambda)

## Explanation why manage lambda function with zip file is better than generating on-fly zip file

With the [discussion](https://github.com/hashicorp/terraform/issues/8344) and [this](https://github.com/hashicorp/terraform/issues/8344#issuecomment-361014199) and more real project practices, I can't find the best way to manage lambda function with all languages and keep zip file updated on-fly properly.

I don't want to commit the zip file directly in repository.

So manage lambda function's zip file on s3 bucket is the best way, this lambda terraform module can be simplified a lot. 

I would recommend you to add a pre-hook to run a build, zip lambda packages and upload to nominated s3 bucket with versioning.

## Features

* Only appears in the Terraform plan when there are legitimate changes.
* Creates a standard IAM role and policy for CloudWatch Logs.
  * You can add additional policies if required.

## Requirements

* Linux/Unix/Windows

## Terraform version compatibility

| Module version | Terraform version |                   Notes                         |
|----------------|-------------------|-------------------------------------------------|
| 2.x.x          | 0.12.x            | s3 bucket only                                  |
| 1.x.x          | 0.12.x            | filename only, please get updates from upstream |
| 0.x.x          | 0.11.x            | filename only, please get updates from upstream |

## Usage

```js
module "lambda" {
  source = "github.com/claranet/terraform-aws-lambda"

  function_name = "deployment-deploy-status"
  description   = "Deployment deploy status task"
  handler       = "main.lambda_handler"
  runtime       = "python3.6"
  timeout       = 300

  // Specify a file or directory for the source code.
  s3_bucket = "unique_s3_bucket_name"
  s3_key    = "dev/lambda-v1.0.3.zip" 

  // Attach a policy.
  policy = {
    json = data.aws_iam_policy_document.lambda.json
  }

  // Add a dead letter queue.
  dead_letter_config = {
    target_arn = aws_sqs_queue.dlq.arn
  }

  // Add environment variables.
  environment = {
    variables = {
      SLACK_URL = var.slack_url
    }
  }

  // Deploy into a VPC.
  vpc_config = {
    subnet_ids         = [aws_subnet.test.id]
    security_group_ids = [aws_security_group.test.id]
  }
}
```

## Inputs

Inputs for this module are the same as the [aws_lambda_function](https://www.terraform.io/docs/providers/aws/r/lambda_function.html) resource with the following additional arguments:

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| **s3\_bucket** | The s3 bucket containing your Lambda zip file | `string` | | yes |
| **s3\_key** | The s3 object key containing your Lambda zip file | `string` | | yes |
| **s3\_object\_version** | The s3 object version id containing your Lambda zip file | `string` | | no |
| cloudwatch\_logs | Set this to false to disable logging your Lambda output to CloudWatch Logs | `bool` | `true` | no |
| lambda\_at\_edge | Set this to true if using Lambda@Edge, to enable publishing, limit the timeout, and allow edgelambda.amazonaws.com to invoke the function | `bool` | `false` | no |
| policy | An additional policy to attach to the Lambda function role | `object({json=string})` | | no |

The following arguments from the [aws_lambda_function](https://www.terraform.io/docs/providers/aws/r/lambda_function.html) resource are not supported:

* filename

## Outputs

| Name | Description |
|------|-------------|
| function\_arn | The ARN of the Lambda function |
| function\_invoke\_arn | The Invoke ARN of the Lambda function |
| function\_name | The name of the Lambda function |
| function\_qualified\_arn | The qualified ARN of the Lambda function |
| role\_arn | The ARN of the IAM role created for the Lambda function |
| role\_name | The name of the IAM role created for the Lambda function |
