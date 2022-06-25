init: 
	terraform init

plan: 
	terraform plan -var-file=local.tfvars

apply:
	terraform apply -var-file=local.tfvars

destroy:
	terraform destroy -var-file=local.tfvars