variable "api_id" {}

variable "name" {}

variable "resource_id" {}

variable "http_method" {}

variable "invoke_arn" {}

variable "authorization" {
  default     = "NONE"
}

variable "request_validator_id" {
  type        = string
  description = "Request Validator Id"
  default = null
}

variable "method_request_parameters" {
  type        = map
  default     = {}
}

variable "model" {
  type    = string
  default = "Empty"
}

variable "integration_request_parameters" {
  type        = map
  default     = {}
}

variable "request_templates" {
  type        = map
  default     = {}
}

variable "responses" {
  type        = list
  default     = []
}