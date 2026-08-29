## Random IDs creation
resource "random_id" "myrandom" {
  byte_length = 4

}


## S3 Bucket Creation
resource "aws_s3_bucket" "mybucket_website" {
  bucket = "my-store-${random_id.myrandom.hex}"
}

resource "aws_s3_bucket_public_access_block" "mybucket_publicaccess" {
  bucket                  = aws_s3_bucket.mybucket_website.id
  block_public_policy     = false
  block_public_acls       = false
  restrict_public_buckets = false
  ignore_public_acls      = false
}


## S3 Website Configuration
resource "aws_s3_bucket_website_configuration" "mybucket_static_website" {
  bucket = aws_s3_bucket.mybucket_website.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}


## S3 Policy Definition
resource "aws_s3_bucket_policy" "mybucket_policy" {
  bucket = aws_s3_bucket.mybucket_website.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGet"
        Effect    = "Allow"
        Principal = "*"
        Action    = "S3:GetObject"
        Resource  = "${aws_s3_bucket.mybucket_website.arn}/*"
      }
    ]
  })

  depends_on = [aws_s3_bucket.mybucket_website, aws_s3_bucket_public_access_block.mybucket_publicaccess]
}

## Uploading "_html" Files to S3 as BLOBS!!! 
resource "aws_s3_object" "index_html" {
  bucket       = aws_s3_bucket.mybucket_website.id
  key          = "index.html"
  source       = "build/index.html"
  etag         = filemd5("build/index.html")
  content_type = "text/index"
}

resource "aws_s3_object" "error_html" {
  bucket       = aws_s3_bucket.mybucket_website.id
  key          = "error.html"
  source       = "build/error.html"
  etag         = filemd5("build/error.html")
  content_type = "text/error"
}

