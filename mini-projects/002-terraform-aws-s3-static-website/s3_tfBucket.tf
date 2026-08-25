
## Global TAGS
locals {
  tags = {
    ProjectName = "002-terraform-aws-s3-static-website"
    IaCUsed     = "Terraform"
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
  bucket                  = aws_s3_bucket.my_s3.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}


## S3 Bucket Website Declaration
resource "aws_s3_bucket_website_configuration" "mybucket_website" {
  bucket = aws_s3_bucket.my_s3.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}


## S3 Policy Definition
resource "aws_s3_bucket_policy" "mybucket_policy" {
  bucket = aws_s3_bucket.my_s3.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid       = "PublicReadGet"
      Effect    = "Allow"
      Principal = "*"
      Action    = "S3:GetObject"
      Resource  = "${aws_s3_bucket.my_s3.arn}/*"
    }]
  })

  depends_on = [aws_s3_bucket.my_s3, aws_s3_bucket_public_access_block.myS3_public_access]

}


resource "aws_s3_object" "index_html" {
  bucket       = aws_s3_bucket.my_s3.id
  key          = "index.html"
  source       = "${path.module}/WebSite/index.html"
  etag         = filemd5("${path.module}/WebSite/index.html")
  content_type = "text/html"
}

resource "aws_s3_object" "error_html" {
  bucket       = aws_s3_bucket.my_s3.id
  key          = "error.html"
  source       = "${path.module}/WebSite/error.html"
  etag         = filemd5("${path.module}/WebSite/error.html")
  content_type = "text/html"
}

resource "aws_s3_object" "privacy_html" {
  bucket       = aws_s3_bucket.my_s3.id
  key          = "privacy.html"
  source       = "${path.module}/WebSite/privacy.html"
  etag         = filemd5("${path.module}/WebSite/privacy.html")
  content_type = "text/html"
}

