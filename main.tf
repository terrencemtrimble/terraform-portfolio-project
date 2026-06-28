provider "aws" {
  region = "us-east-1"
}

#s3 bucket
resource "aws_s3_bucket" "nextjs-blog-bucket" {
  bucket = "nextjs-portfolio-bucket-tt-2026"
}

# Ownership Control 
resource "aws_s3_bucket_ownership_controls" "nextjs-blog-bucket-ownership" {
  bucket = aws_s3_bucket.nextjs-blog-bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "nextjs-blog-bucket-public-access" {
  bucket = aws_s3_bucket.nextjs-blog-bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Bucket ACL
resource "aws_s3_bucket_acl" "nextjs-blog-bucket-acl" {
  bucket = aws_s3_bucket.nextjs-blog-bucket.id

  depends_on = [
    aws_s3_bucket_ownership_controls.nextjs-blog-bucket-ownership,
    aws_s3_bucket_public_access_block.nextjs-blog-bucket-public-access ]
    acl = "public-read"
}

# S3 Bucket Policy
resource "aws_s3_bucket_policy" "nextjs-blog-bucket-policy" {
  bucket = aws_s3_bucket.nextjs-blog-bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "PublicReadGetObject"
        Effect = "Allow"
        Principal = "*"
        Action = ["s3:GetObject"]
        Resource = "${aws_s3_bucket.nextjs-blog-bucket.arn}/*"
      }
    ]
  })

}
# origin access identity
resource "aws_cloudfront_origin_access_identity" "nextjs-blog-oai" {
  comment = "OAI for nextjs blog"
}
# CloudFront Distribution
resource "aws_cloudfront_distribution" "nextjs-blog-cf-distribution" {
  enabled = true
  default_root_object = "index.html"

  origin {
    domain_name = aws_s3_bucket.nextjs-blog-bucket.bucket_regional_domain_name
    origin_id   = "myS3Origin"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.nextjs-blog-oai.cloudfront_access_identity_path
    }
  }

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "myS3Origin"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}