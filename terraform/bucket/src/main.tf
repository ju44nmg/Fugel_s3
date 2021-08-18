
resource "aws_iam_role" "s3_role" {
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

data "aws_iam_policy_document" "bucket_policy" {
  statement {
    principals {
      type        = "AWS"
      identifiers = [aws_iam_role.s3_role.arn]
    }

    actions = [
      "s3:ListBucket",
    ]

    resources = [
      "arn:aws:s3:::${var.bucket_name}",
    ]
  }
}


module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"
  bucket = var.bucket_name
  acl    = "private"
  tags = var.tags
  attach_policy = true
  policy        = data.aws_iam_policy_document.bucket_policy.json
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}



resource "null_resource" "run_script" {
  depends_on          = [module.s3_bucket]
  provisioner "local-exec" {
      command = "bash ${path.module}/files/script.sh"
      environment = {
        bucket_name = var.bucket_name
      }
  }
}
