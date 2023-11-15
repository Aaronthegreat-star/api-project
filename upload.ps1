$BUCKETNAME = "bucket-for-my-lambda-functions"

if (-not ($args.Count -eq 4)) {
    Write-Host "No Arguments Passed. Arguments must be exactly 4. Try: create, read, update, delete"
    exit 1
} else {
    Write-Host "Compressing Functions...."
    Start-Sleep -Seconds 2

    $functions = $args[0..3]

    foreach ($function in $functions) {
        $path = Join-Path (Get-Location) "lambda-functions\$function-function"
        Compress-Archive -Path "$path\$function-function.py" -DestinationPath "$path\$function-function.zip" 
    }

    $region = Read-Host "Enter Your Region"

    Write-Host "Creating S3 Bucket..."
    Start-Sleep -Seconds 2

    aws s3api create-bucket --bucket $BUCKETNAME --region $region

    Write-Host "Copying Function Artifacts to S3 Bucket..."
    Start-Sleep -Seconds 2

    foreach ($function in $functions) {
        aws s3 cp "$(Get-Location)\lambda-functions\$function-function\$function-function.zip" "s3://$BUCKETNAME/v2.0.0/$function-function.zip"
    }

    Write-Host "Creating Infrastructure..."
    Start-Sleep -Seconds 2

    terraform init
    terraform apply -auto-approve

    Write-Host "DONE"
    exit 0
}
