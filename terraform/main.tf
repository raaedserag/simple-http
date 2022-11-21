terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.40.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.2.3"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "4.0.4"
    }
  }
  backend "s3" {}
  required_version = ">= 1.3.5"
}

provider "aws" {}
provider "local" {}
provider "tls" {}

# Modules
module "eks_vpc" {
  source                      = "./modules/AWS-EKS-Vpc-2Azs-4Subnets-tf-module"
  vpc_cidr_block              = var.vpc_cidr_block
  subnet_public_a_cidr_block  = var.subnet_public_a_cidr_block
  subnet_private_a_cidr_block = var.subnet_private_a_cidr_block
  subnet_public_b_cidr_block  = var.subnet_public_b_cidr_block
  subnet_private_b_cidr_block = var.subnet_private_b_cidr_block
}
module "eks_cluster" {
  source                   = "./modules/AWS-Eks-Cluster-tf-module"
  eks_cluster_name         = var.eks_cluster_name
  eks_nodes_ssh_public_key = tls_private_key.key_pair.public_key_openssh
  eks_vpc_id               = module.eks_vpc.vpc.id
  eks_private_subnets = [
    module.eks_vpc.subnet_private_a.id,
    module.eks_vpc.subnet_private_b.id
  ]
  eks_public_subnets = [
    module.eks_vpc.subnet_public_a.id,
    module.eks_vpc.subnet_public_b.id
  ]
}
module "simple_app_staging_k8s" {
  source = "./modules/simple-http-environment-setup"
  k8s_cluster_config = {
    endpoint               = module.eks_cluster.simple_http_cluster.endpoint
    cluster_ca_certificate = module.eks_cluster.simple_http_cluster.certificate_authority[0].data
    name                   = module.eks_cluster.simple_http_cluster.id
  }
  environment                      = "staging"
  app_name                         = var.app_name
  version_number                   = var.version_number
  app_static_environment_variables = var.app_static_environment_variables
  rds_config = {
    db_user                     = var.rds_user_name
    db_password                 = var.rds_user_password
    initial_db_name             = var.rds_db_name
    vpc_id                      = module.eks_vpc.vpc.id
    subnets                     = [module.eks_vpc.subnet_private_a.id, module.eks_vpc.subnet_private_b.id]
    allowed_inbound_cidr_blocks = [module.eks_vpc.subnet_private_a.cidr_block, module.eks_vpc.subnet_private_b.cidr_block]
  }
  # app_container_image = "${module.eks_cluster.simple_http_ecr_repo.repository_url}:staging"
  app_container_image = "raaedserag/simple-http-server:staging"
  app_replicas_count  = var.app_replicas_count
}
module "simple_app_production_k8s" {
  source = "./modules/simple-http-environment-setup"
  k8s_cluster_config = {
    endpoint               = module.eks_cluster.simple_http_cluster.endpoint
    cluster_ca_certificate = module.eks_cluster.simple_http_cluster.certificate_authority[0].data
    name                   = module.eks_cluster.simple_http_cluster.id
  }
  environment                      = "production"
  app_name                         = var.app_name
  version_number                   = var.version_number
  app_static_environment_variables = var.app_static_environment_variables
  rds_config = {
    db_user                     = var.rds_user_name
    db_password                 = var.rds_user_password
    initial_db_name             = var.rds_db_name
    vpc_id                      = module.eks_vpc.vpc.id
    subnets                     = [module.eks_vpc.subnet_private_a.id, module.eks_vpc.subnet_private_b.id]
    allowed_inbound_cidr_blocks = [module.eks_vpc.subnet_private_a.cidr_block, module.eks_vpc.subnet_private_b.cidr_block]
  }
  # app_container_image = "${module.eks_cluster.simple_http_ecr_repo.repository_url}:production"
  app_container_image = "raaedserag/simple-http-server:production"
  app_replicas_count  = var.app_replicas_count
}

module "simple_http_pipeline"{
  source = "./modules/simple-http-pipeline"
  github_repository_name = var.github_repository_name
  github_repository_branch = var.github_repository_branch
  staging_environment_config = {
    name = "staging"
    # image_name = "${module.eks_cluster.simple_http_ecr_repo.repository_url}:staging"
    image_name = "raaedserag/simple-http-server:staging"
  }
}