
## Global TAGS
locals {
  tags = {
    ProjectName = "002-terraform-aws-s3-static-website"
    IaCUsed = "Terraform"
  }
}

## Generate RANDOM ids for my S3 Bucket Name
resource "random_id" "my_random" {
  byte_length = 5
}


## S3 Bucket
resource "aws_s3_bucket" "my_s3" {
  bucket = "mystore-${random_id.my_random.hex}"
  tags = merge(local.tags, {
    Name = "aws_bucket"
  })
}


## S3 Bucket Public Access
resource "aws_s3_bucket_public_access_block" "myS3_public_access" {
  bucket = aws_s3_bucket.my_s3.id
  block_public_acls = false
  block_public_policy = false
  ignore_public_acls = false
  restrict_public_buckets = false
}


## S3 Bucket Website Declaration
resource "aws_s3_bucket_website_configuration" "mybucket_website" {
  bucket = aws_s3_bucket.my_s3.id

  index_document {
    suffix = "index.cshtml"
  }

  error_document {
    key = "error.cshtml"
  }

  
}




