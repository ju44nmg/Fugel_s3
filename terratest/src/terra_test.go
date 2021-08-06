
package test

import (
  "fmt"
  "testing"
  "github.com/gruntwork-io/terratest/modules/aws"
  "github.com/gruntwork-io/terratest/modules/terraform"
)

var awsRegion = "us-east-1"
var s3BucketName = "testingbucketjmg-from-terratest"

func TestTerraformAwsS3(t *testing.T) {
	t.Parallel()

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../../terraform/src",
		Vars: map[string]interface{}{
			"aws_region":        awsRegion,
			"bucket_name":       s3BucketName,
		},
	})
  //Terraform init & apply
	terraform.InitAndApply(t, terraformOptions)

  //Check bucket exists
  aws.AssertS3BucketExists(t, awsRegion, s3BucketName)
  //assert bucket exists by checking its name, and print it
	bucketID := terraform.Output(t, terraformOptions, "s3_bucket_id")
  fmt.Println("Bucket name is ", bucketID)

  //Check bucket files and print, not the best approach but will work
  for i := 1; i < 3; i++ {
      file := fmt.Sprintf("files/test%d.txt", i)
      aws.GetS3ObjectContents(t, awsRegion, s3BucketName, file)
		  fmt.Printf("File %s exists", file)
	}

  //Empty bucket before destroy
  aws.EmptyS3Bucket(t, awsRegion, s3BucketName)

  // terraform Destroy
  defer terraform.Destroy(t, terraformOptions)

}
