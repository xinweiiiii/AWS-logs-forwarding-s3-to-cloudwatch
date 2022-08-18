terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# define AWS as provider
provider "aws" {
    region = "ap-southeast-1"
}

// If you want to store your terraform state in S3
# # Terraform remote state - Store in S3
# terraform {
#     backend "s3"{
#         bucket = "logs-forwarding"
#         key = "logs-forwarding/terraform.tfstate"
#         region = "ap-southeast-1"
#     }
# }
