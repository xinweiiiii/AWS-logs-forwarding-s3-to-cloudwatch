# ------------------------------------------------------------
# Cloudwatch log group for ALB Access Logs
# ------------------------------------------------------------
resource "aws_cloudwatch_log_group" "alb_access_log_group" {
  name = "${var.environment}-alb-access-log"
  retention_in_days = 400
}
