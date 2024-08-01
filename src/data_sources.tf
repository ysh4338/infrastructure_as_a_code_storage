# must be setting "aws configure" or "Environment Variables"
data "aws_caller_identity" "aws_account_info" {}

# Use data and filtering to get ami information for amazon_linux_2023.  
data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["al2023-ami-2023*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}