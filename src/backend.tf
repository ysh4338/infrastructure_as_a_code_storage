terraform {
  backend "s3" {
    bucket         = "aj-genai-bucket-tf-backend"
    key            = "terraform-sample/aj-genai-bucket-tf-backend"
    region         = "ap-northeast-2"
    encrypt        = true
    dynamodb_table = "aj-genai-dynamodb-tf-state-table"
  }
}
