variable "environment" {
  description = "Code Environment"
}

variable "s3_source_arn_event_notification" {
  description = "The S3 ARN that will trigger the lambda through even notification"
}

variable "s3_bucket_name" {
  description = "S3 bucket that is storing the logs"
}