# Introduction
This file explain how to user this module by developer and what are input parameters are required, output variable and prerequisite and all.
This module will create following resources:
  - S3 Bucket
  - test1.txt and text2.txt, both containing the date when the code was executed.

# Prerequisites
This module has following dependencies:
  1. Configured AWS CLI with active account
    1. Permission over the account to create an S3 Bucket

## Inputs (example)
| Name           | Description                            | Type   | Default       | Required |
|:---------------|:---------------------------------------|:-------|:--------------|:---------|
| aws_region         | Region to configure terraform        | string | us-east-1             | true     |
| bucket_name    | Name of the Bucket | string | testingbucket             | true     |
| tags | Tags for the Bucket         | string | Environment: Test, Contains: Test  | true     |


## Outputs (example)
 * Bucket ID
  * s3_bucket_id = "nameofthebucket"

## Usage

Replace the variables in ```variables.tf```, first run ```terraform init``` to download dependencies, and then run ```terraform apply --auto-approve``` in the ```/src``` folder to run the code
