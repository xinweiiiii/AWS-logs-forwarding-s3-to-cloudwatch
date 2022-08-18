# ------------------------------------------------------------
# iam role for lambda execution to forward logs from s3
# ------------------------------------------------------------
resource "aws_iam_role" "lambda_forward_logs_s3_cloudwatch_role" {
  name                 = "${var.environment}-lambda-forward-logs-s3-cloudwatch-role"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "lambda.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF
  tags = merge({
    Name = "${var.environment}-iam-role"
  }, var.tags
  )
}

# Policy definition for the IAM role
resource "aws_iam_role_policy" "lambda_forward_logs_s3_cloudwatch_role_policy" {
  name   = "${var.environment}-lambda-forward-logs-s3-cloudwatch-policy"
  role   = aws_iam_role.lambda_forward_logs_s3_cloudwatch_role.id
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams",
          "logs:PutLogEvents",
          "logs:GetLogEvents",
          "logs:FilterLogEvents",
          "ec2:CreateNetworkInterface",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DeleteNetworkInterface"
        ],
        "Resource": "*"
      },
      {
        "Action": [
          "s3:GetObject"
        ],
        "Effect": "Allow",
        "Resource": ["*"]
      }
    ]
  }
  EOF
}
