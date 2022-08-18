# ------------------------------------------------------------
# Define global environments
# ------------------------------------------------------------
variable "environment" {
    type          = string
    description   = "Environment name or equivalent for CI CD and resource naming purpose."
}

variable "s3_source_arn_event_notification" {
    type            = string
    description   = "The S3 ARN that will trigger the lambda through even notification"
}

variable "s3_bucket_name" {
    type            = string
    description   = "The S3 bucket name"
}