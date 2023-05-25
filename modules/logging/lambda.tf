# -------------------------------------------------------------------------
# lambda function to forward logs from s3 to cloudwatch (ALB and cloudfront)
# --------------------------------------------------------------------------
data "archive_file" "archive_pipe_logs_s3_cloudwatch_lambda" {
    type        = "zip"
    source_file = "${path.module}/forward-logs-cloudwatch-lambda/index.js"
    output_path = "${path.module}/forward-logs-cloudwatch-lambda/archive.zip"
}

resource "aws_lambda_function" "forward_logs_s3_cloudwatch" {
    filename         = "${path.module}/forward-logs-cloudwatch-lambda/archive.zip"
    function_name    = "${var.environment}-forward-logs"
    role             = aws_iam_role.lambda_forward_logs_s3_cloudwatch_role.arn
    handler          = "index.handler"
    runtime          = "nodejs14.x"
    timeout       = 30

    // Redeploy when lambda function code change
    source_code_hash = data.archive_file.archive_pipe_logs_s3_cloudwatch_lambda.output_base64sha256

    tracing_config {
        mode = "Active"
    }

    environment {
        variables = {
            environment = var.environment
            logGroupName = aws_cloudwatch_log_group.alb_access_log_group.name
        }
    }

    // Optional can route through internet
    # vpc_config {
    #     subnet_ids = var.subnet_ids
    #     security_group_ids = var.security_group_ids
    # }
}

resource "aws_lambda_permission" "allow_bucket_forward_logs" {
    statement_id  = "AllowExecutionFromS3Bucket"
    action        = "lambda:InvokeFunction"
    function_name = aws_lambda_function.forward_logs_s3_cloudwatch.arn
    principal     = "s3.amazonaws.com"
    source_arn    = var.s3_source_arn_event_notification
#    source_account = var.account_id
}

// To manually configure in the console
resource "aws_s3_bucket_notification" "aws-lambda-trigger-alb-cloudfront" {
    depends_on = [aws_lambda_permission.allow_bucket_forward_logs]
    bucket = var.s3_bucket_name
    lambda_function {
        lambda_function_arn = aws_lambda_function.forward_logs_s3_cloudwatch.arn
        events              = ["s3:ObjectCreated:*"] // When new object created in S3 it will trigger the lambda function
    }
}
