# AWS EKS + S3 + VPC

This module contains the following:

  - Terraform Code
  - Terratest Code
  - Github Actions yml

**Everything contains its own README file inside ```folder/docs``` folder**

# Usage
To run the Github Actions:
- Create the following secrets:
  - AWS_ACCESS_KEY_ID
  - AWS_SECRET_ACCESS_KEY
  - AWS_DEFAULT_REGION
- The Action will run on push, or pull request, you can also [run it manually](https://docs.github.com/en/actions/managing-workflow-runs/manually-running-a-workflow) if necessary.

To run the Terraform Code:

- Configure AWS CLI with an active account
- go to ```terraform/main_tf```folder, and then run ```terraform apply --auto-approve``` to run the code

#Terratest hasnt been made yet
To run the Terratest Code:

- As with Terraform, configure the AWS CLI with an active account
- go to ```terratest/src``` and run ```go test```
