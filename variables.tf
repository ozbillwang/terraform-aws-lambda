# Required variables.

variable "function_name" {
  type = string
}

variable "handler" {
  type = string
}

variable "runtime" {
  type = string
}

variable "s3_bucket" {
  description = "(Optional) The S3 bucket location containing the function's deployment package. Conflicts with filename(source_path). This bucket must reside in the same AWS region where you are creating the Lambda function."
  type        = string
  default     = null
}

variable "s3_key" {
  description = "(Optional) The S3 key of an object containing the function's deployment package. Conflicts with filename."
  type        = string
  default     = null
}

# Optional variables specific to this module.
variable "s3_object_version" {
  description = "(Optional) The object version containing the function's deployment package."
  type        = string
  default     = null
}

# Optional variables specific to this module.
variable "cloudwatch_logs" {
  description = "Set this to false to disable logging your Lambda output to CloudWatch Logs"
  type        = bool
  default     = true
}

variable "lambda_at_edge" {
  description = "Set this to true if using Lambda@Edge, to enable publishing, limit the timeout, and allow edgelambda.amazonaws.com to invoke the function"
  type        = bool
  default     = false
}

variable "policy" {
  description = "An additional policy to attach to the Lambda function role"
  type = object({
    json = string
  })
  default = null
}

locals {
  publish = var.lambda_at_edge ? true : var.publish
  timeout = var.lambda_at_edge ? min(var.timeout, 5) : var.timeout
}

# Optional attributes to pass through to the resource.

variable "description" {
  type    = string
  default = null
}

variable "layers" {
  type    = list(string)
  default = null
}

variable "kms_key_arn" {
  type    = string
  default = null
}

variable "memory_size" {
  type    = number
  default = null
}

variable "publish" {
  type    = bool
  default = false
}
variable "reserved_concurrent_executions" {
  type    = number
  default = null
}

variable "tags" {
  type    = map(string)
  default = null
}

variable "timeout" {
  type    = number
  default = 3
}

# Optional blocks to pass through to the resource.

variable "dead_letter_config" {
  type = object({
    target_arn = string
  })
  default = null
}

variable "environment" {
  type = object({
    variables = map(string)
  })
  default = null
}

variable "tracing_config" {
  type = object({
    mode = string
  })
  default = null
}


variable "vpc_config" {
  type = object({
    security_group_ids = list(string)
    subnet_ids         = list(string)
  })
  default = null
}
