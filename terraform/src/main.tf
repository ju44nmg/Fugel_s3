provider "aws" {
  region = var.aws_region
}

module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"
  bucket = var.bucket_name
  acl    = "private"
  tags = var.tags
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
