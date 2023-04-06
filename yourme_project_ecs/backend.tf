# terraform {
#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = "~> 4.18.0"

#     }
#   }

#  backend "s3" {
#    bucket   = "yourme-terra-statefile-bucket"  #create s3 bucket on AWS.
#    key      = "state.tfstate"
#    region   = "eu-west-2"
#    encrypt  = true
#    profile = "yourme-kube"
#  }
# }