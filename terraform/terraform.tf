terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.34.0"
    }
  }

  backend "s3" {
    bucket         = "imagify-terraform-state"
    key            = "terraform/imagify.tfstate"
    region         = "us-east-1"
    dynamodb_table = "imagify-terraform-lock"
  }
}

