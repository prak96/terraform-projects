
## AWS S3 Bucket Static Website
output "static_endpoint_endpoint" {
  value = aws_s3_bucket_website_configuration.mybucket_website.website_endpoint
}

