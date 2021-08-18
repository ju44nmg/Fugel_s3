# Introduction
This file explain how to user this module by developer and what are input parameters are required, output variable and prerequisite and all.
This module will run the following code:
- Run Terraform code that will create, check and output:
  - S3 Bucket
  - test1.txt and text2.txt, both containing the date when the code was executed.
- Delete the terraform created infrastructure

# Prerequisites
This module has following dependencies:
  1. Configured AWS CLI with active account
    1. Permission over the account to create an S3 Bucket


## Outputs
 * Bucket name is "nameofthebucket"
 * Files "test**y**.txt" exists

## Usage

inside the ```src``` folder, run ```go test```
