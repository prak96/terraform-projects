output "static_endpoint_endpoint" {
  value = aws_s3_bucket_website_configuration.mybucket_static_website.website_endpoint
}