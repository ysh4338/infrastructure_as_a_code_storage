terraform {
  backend "s3" {
    bucket         = "sample-env-bucket-tf-backend"
    key            = "terraform-sample/sample-env-bucket-tf-backend"
    region         = "ap-northeast-2"
    encrypt        = true
    dynamodb_table = "sample-env-dynamodb-tf-state-table"
  }
}
