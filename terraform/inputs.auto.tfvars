vpc_cidr_block              = "10.0.0.0/16"
subnet_public_a_cidr_block  = "10.0.1.0/24"
subnet_public_b_cidr_block  = "10.0.2.0/24"
subnet_private_a_cidr_block = "10.0.11.0/24"
subnet_private_b_cidr_block = "10.0.21.0/24"
eks_cluster_name            = "simple-http-k8s"
app_name                    = "simplehttp"
version_number              = "1.0.0"
app_static_environment_variables = {
  NODE_CONFIG_DIR = "./src/config/environments"
}
app_replicas_count       = 2
github_repository_name   = "BespinGlobalMEA/cloud-devops-engineer-hiring---bespinglobal-mea-raaedserag"
github_repository_branch = "dev"
