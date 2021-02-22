output "s3-website-endpoint" {
  value = aws_s3_bucket.website_bucket.website_endpoint
}