#!make
include .env
export $(shell sed 's/=.*//' .env)

init:
	terraform init \
		-backend-config="bucket=$(TERRAFORM_BACKEND_S3_BUCKET)" \
		-backend-config="key=$(TERRAFORM_BACKEND_S3_KEY)"\
		-backend-config="region=$(TERRAFORM_BACKEND_S3_REGION)"
reconfig:
	terraform init -reconfigure\
		-backend-config="bucket=$(TERRAFORM_BACKEND_S3_BUCKET)" \
		-backend-config="key=$(TERRAFORM_BACKEND_S3_KEY)"\
		-backend-config="region=$(TERRAFORM_BACKEND_S3_REGION)"
		
plan:
	terraform plan 
deploy:
	terraform apply -auto-approve
destroy:
	terraform destroy -auto-approve
k8s_config:
	aws eks update-kubeconfig --name simple-http-k8s
	kubectl config set-context --current --namespace=simplehttp-staging
