helm-dev-apply:
	rm -rf .terraform/terraform.tfstate
	terraform init --backend-config=environments/dev/state.tfvars
	terraform apply -auto-approve -var-file=environments/dev/main.tfvars -var token=$(token)

helm-dev-destroy:
	rm -rf .terraform/terraform.tfstate
	terraform init --backend-config=environments/dev/state.tfvars
	terraform destroy -auto-approve -var-file=environments/dev/main.tfvars -var token=$(token)

helm-prod-apply:
	rm -rf .terraform/terraform.tfstate
	terraform init --backend-config=environments/prod/state.tfvars
	terraform apply -auto-approve -var-file=environments/prod/main.tfvars -var token=$(token)

helm-prod-destroy:
	rm -rf .terraform/terraform.tfstate
	terraform init --backend-config=environments/prod/state.tfvars
	terraform destroy -auto-approve -var-file=environments/prod/main.tfvars -var token=$(token)