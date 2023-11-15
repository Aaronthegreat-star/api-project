#!/bin/bash

BUCKET="bucket-for-my-lambda-functions"

echo "deleting s3 bucket"

sleep 2
aws s3 rb s3://$BUCKET --force

echo "deleting Infrastructure"

sleep 2
terraform destroy -auto-approve