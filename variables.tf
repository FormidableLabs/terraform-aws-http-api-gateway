variable "domain_name" {
  description = "Top level domain name."
  type        = string
  default     = "example.com"
}

variable "enable_access_logs" {
  description = "Enable API Gateway Access Logs"
  default     = false
  type        = bool
}

variable "lambda_function_invoke_arn" {
  description = "(Required) ARN of the lambda the API Gateway will invoke."
  type        = string
}

variable "log_retention_in_days" {
  description = "Log retention in number of days."
  type        = number
  default     = 90
}

variable "namespace" {
  default = ""
}

variable "service" {
  type = string
}

variable "stage" {
  type = string
}

variable "tags" {
  description = "Additional tags to apply to the log group."
  type        = map(any)
  default     = {}
}

variable "throttling_burst_limit" {
  type    = number
  default = null
}

variable "throttling_rate_limit" {
  type    = number
  default = null
}

variable "enable_quota_limits" {
  type    = bool
  default = true
}
