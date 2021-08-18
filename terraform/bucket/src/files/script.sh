#!/usr/bin/env bash

for (( i = 1; i <= 2; i++ )); do
  #write current date to a file
  echo $(date) >files/test${i}.txt
  #Upload file to s3 bucket
  aws s3api put-object --bucket "${bucket_name}" --key files/test${i}.txt --body files/test${i}.txt
done
