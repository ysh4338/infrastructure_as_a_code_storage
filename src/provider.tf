# Configure the AWS Provider
provider "aws" {
  region = "ap-northeast-2"
}
provider "aws" {
  alias  = "us-west-2"
  region = "us-west-2"
}
