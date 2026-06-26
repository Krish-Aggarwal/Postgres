resource "aws_iam_role" "postgres_role" {
  name = "postgres-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "postgres_s3_policy" {
  name = "postgres-s3-backup-policy"
  role = aws_iam_role.postgres_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "s3:PutObject",
        "s3:GetObject",
        "s3:ListBucket",
        "s3:DeleteObject"
      ]
      Resource = [
        var.backup_bucket_arn,
        "${var.backup_bucket_arn}/*"
      ]
    }]
  })
}

resource "aws_iam_instance_profile" "postgres_profile" {
  name = "postgres-profile"
  role = aws_iam_role.postgres_role.name
}