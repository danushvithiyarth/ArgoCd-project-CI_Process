terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    bucket = "danushvithiyarthjaiganesh"
    key    = "terraform-finalproject.tf"
    region = "eu-north-1"
  }
}

provider "aws" {
  region = "eu-north-1"
}