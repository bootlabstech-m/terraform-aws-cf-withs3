variable "region" {
    description = "region of the lamda function"
    type = string
}
variable "role_arn" {
     description = "value"
     type = string
}
variable "source_bucket" {
    description = "source_bucket "
    type = string
}
# variable "lambda_details" {
#     description = "lambda_details"
#     type = list (any)
# }
variable "lambda_function_name" {
    description = "lambda_function_name"
    type = string
}
variable "runtime" {
    description = "runtime"
    type = string
}
variable "memory_size" {
    description = "memory_size"
    type = string
}
variable "timeout" {
    description = "timeout"
    type = string
}
