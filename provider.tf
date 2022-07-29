terraform {
  required_version = "~> 1.2.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.22.0"
    }
  }

  backend "s3" {
    bucket  = "app-runner-rds-terraform"
    region  = "ap-northeast-1"
    key     = "terraform.tfstate"
    encrypt = true
  }
}

provider "aws" {
  region = "ap-northeast-1"
}
