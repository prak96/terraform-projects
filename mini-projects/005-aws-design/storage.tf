
locals {
  storageName = "${var.owner}-${var.env}-store-${random_id.myrandom.hex}" ## Explicitly calling the VALUE of VARIABLES - "OWNER" & "ENV" for creation of PARAMETER - "storageName"
}


# S3 Bucket Configuration

resource "random_id" "myrandom" {
  byte_length = 3

}


## S3 Bucket 
resource "aws_s3_bucket" "prat_bucket" {
  bucket = local.storageName ## Explicitly calling the VALUE of Parameter - "storageName"
  tags = {
    Name = local.storageName ## Explicitly calling the VALUE of Parameter - "storageName"
    Env  = var.env           ## Explicitly calling the INPUT of variable - "env"
  }
}

## S3 Bucket Public Access
resource "aws_s3_bucket_public_access_block" "mybucket_publicaccess" {
  bucket                  = aws_s3_bucket.prat_bucket.id
  block_public_policy     = false
  block_public_acls       = false
  restrict_public_buckets = false
  ignore_public_acls      = false
}