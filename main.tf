terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.16.0"
    }
  }
}

provider "aws" {
  region = "ap-southeast-2"
}

resource "random_pet" "bucket-name" {
  length    = 3
  separator = "-"
}

resource "aws_s3_bucket" "website_bucket" {
  bucket = random_pet.bucket-name.id
  acl    = "public-read"
  website {
    index_document = "index.html"
    error_document = "index.html"
  }
  policy = <<-EOF
  {
    "Version": "2008-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "AWS": "*"
        },
        "Action": "s3:GetObject",
        "Resource": "arn:aws:s3:::${random_pet.bucket-name.id}/*"
      }
    ]
  }
  EOF
}

resource "aws_s3_bucket_object" "index" {
  bucket       = random_pet.bucket-name.id
  key          = "index.html"
  content      = templatefile("index.tpl", { message = var.message })
  content_type = "text/html"
}