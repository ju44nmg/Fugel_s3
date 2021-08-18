variable "aws_region" {
  default     = "us-east-1"
  type        = string
}

variable "bucket_name" {
  default     = "testingbucketjmg"
  type        = string
}

variable "tags" {
  default     = {
    "Environment" = "Test"
    "Contains"    = "Test"
  }
  type        = map(string)
}
