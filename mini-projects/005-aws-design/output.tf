
output "prat-public-ip" {
  value       = aws_instance.Ubuntu-VM.public_ip
  description = "prat-pulic-ip-output"
}

output "prat-vpc-id" {
  value       = aws_vpc.prat_vpc.id
  description = "prat-vpc-id-output"
}

output "prat-s3-id" {
  value       = aws_s3_bucket.prat_bucket.id
  description = "prat-s3-id-output"
}
