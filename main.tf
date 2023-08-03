resource "aws_iam_role" "lambda_role" {
name   = "LambdaRole"
assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "lambda.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
  lifecycle {
    ignore_changes = [tags]
  }
}
resource "aws_iam_policy" "iam_policy_for_lambda" {
 
 name         = "LambdaPolicy"
 path         = "/"
 description  = "AWS IAM Policy for managing aws lambda role"
 policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": [
       "logs:CreateLogGroup",
       "logs:CreateLogStream",
       "logs:PutLogEvents"
     ],
     "Resource": "arn:aws:logs:*:*:*",
     "Effect": "Allow"
   }
 ]
}
EOF
  lifecycle {
    ignore_changes = [tags]
  }
}
resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_role" {
 role        = aws_iam_role.lambda_role.name
 policy_arn  = aws_iam_policy.iam_policy_for_lambda.arn
}

# Create an S3 bucket to hold the function code
resource "aws_s3_bucket" "lambda_function_bucket" {
  bucket = var.source_bucket  
  acl    = "private"
    lifecycle {
    ignore_changes = [tags]
  }
}

# Create a Lambda function with the S3 bucket as the source code
resource "aws_lambda_function" "my_lambda_function" {
  
  function_name = var.lambda_function_name
  handler       = "index.handler"
  runtime       = var.runtime
  memory_size   = var.memory_size
  timeout       = var.timeout
  role          = aws_iam_role.lambda_role.arn

  # The S3 bucket object containing the function code
  source_code_hash = filebase64sha256("${path.module}/function.zip")
  s3_bucket        = aws_s3_bucket.lambda_function_bucket.id
  s3_key           = "function.zip"
    lifecycle {
    ignore_changes = [tags]
  }
}

# Upload the function code to the S3 bucket
resource "aws_s3_bucket_object" "function_zip" {
  bucket = aws_s3_bucket.lambda_function_bucket.id
  key    = "function.zip"
  source = "function.zip"
    lifecycle {
    ignore_changes = [tags]
  }
}
