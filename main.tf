module "logging" {

source = "./modules/logging"
    environment          = var.environment
    s3_bucket_name       = var.s3_bucket_name
    s3_source_arn_event_notification = var.s3_source_arn_event_notification
}
