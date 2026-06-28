terraform {
  backend "s3" {
    bucket = "tt-s3-bucket-project"
    key    = "global/s3/terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "tt-db-table"  

  }
}