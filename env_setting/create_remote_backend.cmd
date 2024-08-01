
set "ENV_NAME=%1"

aws s3 mb s3://%ENV_NAME%-bucket-tf-backend --region ap-northeast-2
aws dynamodb create-table ^
    --table-name %ENV_NAME%-dynamodb-tf-state-table ^
    --attribute-definitions AttributeName=LockID,AttributeType=S ^
    --key-schema AttributeName=LockID,KeyType=HASH ^
    --provisioned-throughput "{\"ReadCapacityUnits\":5,\"WriteCapacityUnits\":5}" ^
    --region ap-northeast-2