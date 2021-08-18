
variable "aws_region" {
  default = "us-east-1"
 }

variable "bucket_name" {
  default     = "testingbucketjmg"
  type        = string
}

variable "tags_bucket" {
  default     = {
    "Environment" = "Test"
    "Contains"    = "Test"
  }
  type        = map(string)
}



variable "eks_name" {
  description = "EKS Name"
  default = "Mi_cluster"
  type = string
}

variable "eks_version" {
  description = "version of Kubernees for thi cluster"
  default = "1.17"
  type = string
}

variable "tags_ec2" {
  description = "tag list"
  type = map(string)
  default = {
    tag1 = "tag1"
    tag2 = "tag2"
    tag3 = "tag3"
    }
}
################################################
#Cluster nodes
################################################
variable "ec2" {
  description = "Detailed list of intances for the cluster"
  type = list(object({
      name = string
      instance_type = string
      additional_userdata = string
      asg_desired_capacity = number
#      additional_security_group_ids = list(string)
    }))
  default = [
    {
      name = "worker"
      instance_type = "t2.small"
      additional_userdata = "echo foo bar"
      asg_desired_capacity = 2
    }
  ]

}

variable "ingress_annotations" {
  type = map(string)
  default = {
#  "controller.service.httpPort.targetPort"                                                                    = "http",
#  "controller.service.httpsPort.targetPort"                                                                   = "https",
  "controller.service.annotations.alb\\.ingress\\.kubernetes\\.io/ingress.class"                             = "alb",
  "controller.service.annotations.alb\\.ingress\\.kubernetes\\.io/scheme"                                    = "internal",
  "controller.service.annotations.alb\\.ingress\\.kubernetes\\.io/target-type"                                = "instance"
  }
}
