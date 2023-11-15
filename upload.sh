#!/bin/bash

BUCKET="bucket-for-my-lambda-functionse
export BUCKET="bucket-for-my-lambda-functions"
echo "s3_bucket_name = "$BUCKET" > terraform.tfvars

if [[ -z $1 || -z $2 || -z $3 || -z $4]]; then
    echo"No Arguemengts Passed. Arguments must be 4. Try: create-function, read-function, update-function, delete-function"
    exit 1

else:
    echo"compressing the functions"

    sleep 2

    cd $(pwd)/Lambda-functions/${1}/
    zip ${1}.zip $1.py

    cd -

    cd $(pwd)/Lambda-functions/${2}/
    zip ${2}.zip $2.py

    cd -

    cd $(pwd)/Lambda-functions/${3}/
    zip ${3}.zip $3.py

    cd -

    cd $(pwd)/Lambda-functions/${4}/
    zip ${4}.zip $4.py

    cd -

    read -p "Enter the region to deploy" : REGION

    echo "creating s3 bucket"

    sleep 2
    
    aws s3api create-bucket --bucket $BUCKET --region $REGION

    echo "cppying functions dependecies into the s3 bucket"

    sleep 2

     aws cp cd $(pwd)/Lambda-functions/${1}/${1}.zip s3://$BUCKET/v2.0.0/${1}.zip

     aws cp cd $(pwd)/Lambda-functions/${2}/$2}.zip s3://$BUCKET/v2.0.0/${2}.zip

     aws cp cd $(pwd)/Lambda-functions/${3}/${3}.zip s3://$BUCKET/v2.0.0/${3}.zip

     aws cp cd $(pwd)/Lambda-functions/${4}/${4}.zip s3://$BUCKET/v2.0.0/${4}.zip

     echo"create Infrastucture"

     sleep 2

     terraform init

    terraform -auto-approve 

    echo "DONE"

    exit 0

fi