provider "aws" {
  region = var.aws_region
}

module "bucket" {
  source      =  "../bucket/src"
  bucket_name = var.bucket_name
  tags        = var.tags_bucket
}

module "vpc" {
  source =  "../vpc/src"
  #all the vars are inside the module lol
}

# module "eks" {
#   source              = "../eks/src"
#   eks_name            = var.eks_name
#   vpc                 = module.vpc.vpc_id
#   eks_version         = var.eks_version
#   subnets             = [module.vpc.private_subnets, module.vpc.public_subnets]
#   tags                = var.tags_ec2
#   ec2                 = var.ec2
#   ingress_annotations = var.ingress_annotations
#   depends_on          = [module.vpc]
# }

# I had to load eks here, bcs of providers conflict, it is ugly but it works
################################################
# Prerequisites
################################################
provider "kubernetes" {
  host                   = data.aws_eks_cluster.EKSCluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.EKSCluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
  load_config_file       = false
}

data "aws_eks_cluster" "EKSCluster" {
  name     = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}
################################################
# Create EKS Cluster
################################################
module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = var.eks_name
  cluster_version = var.eks_version
  subnets         = [module.vpc.private_subnets, module.vpc.public_subnets]
  vpc_id          = module.vpc.vpc_id
  worker_groups   = var.ec2
  tags            = var.tags_ec2
  manage_aws_auth = true
  workers_additional_policies = ["arn:aws:iam::aws:policy/AmazonS3FullAccess"]
  depends_on          = [module.vpc]
}
################################################
# NLB
################################################

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.EKSCluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.EKSCluster.certificate_authority.0.data)
    token                  = data.aws_eks_cluster_auth.cluster.token
  }
}

resource "helm_release" "ingress" {
  name       = "traefik-ingress"
  chart      = "traefik"
  repository = "https://helm.traefik.io/traefik"
  version    = "9.8.3"
  timeout    = "600"

  values = [
    file("files/traefik.yml")
  ]
#
  dynamic "set" {
    for_each = var.ingress_annotations

    content {
      name  = set.key
      value = set.value
      type  = "string"
    }
  }
}
