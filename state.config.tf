terraform {
  backend "s3" {
    bucket         = "terraform-n8n-qm"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-n8n-qm-lock"
  }
}
