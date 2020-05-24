output "arn" {
  description = "The ARN of the bucket created"
  value       = aws_s3_bucket.this.arn
}

output "dns" {
  description = "The DNS domain name of the bucket created"
  value       = aws_s3_bucket.this.bucket_domain_name
}

output "name" {
  description = "The Name of the bucket created"
  value       = aws_s3_bucket.this.id
}

output "region" {
  description = "The AWS region this bucket resides in"
  value       = aws_s3_bucket.this.region
}

output "website_endpoint" {
  description = "The website endpoint, if the bucket is configured with a website. If not, this will be an empty string"
  value       = aws_s3_bucket.this.website_endpoint
}

output "website_domain" {
  description = "The domain of the website endpoint, if the bucket is configured with a website. If not, this will be an empty string. This is used to create Route 53 alias records"
  value       = aws_s3_bucket.this.website_domain
}
