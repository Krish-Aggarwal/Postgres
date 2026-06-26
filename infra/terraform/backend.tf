terraform {
  backend "s3" {
    bucket         = "krish-postgres-tfstate-us-east-1"
    key            = "postgres/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
  }
}
