variable "aws_region" {
  default     = "us-east-1"
  description = "AWS region"
}

variable "vpc_cidr" {
  default     = "10.0.0.0/16"
  description = "VPC CIDR block"
}

variable "public_subnet_cidr" {
  default     = "10.0.1.0/24"
  description = "Public subnet CIDR - AZ-a - bastion"
}

variable "private_subnet_1_cidr" {
  default     = "10.0.11.0/24"
  description = "Private subnet CIDR - AZ-a - primary"
}

variable "private_subnet_2_cidr" {
  default     = "10.0.12.0/24"
  description = "Private subnet CIDR - AZ-b - sync standby"
}

variable "private_subnet_3_cidr" {
  default     = "10.0.13.0/24"
  description = "Private subnet CIDR - AZ-c - async standby"
}

variable "instance_type" {
  default     = "t3.micro"
  description = "EC2 instance type for all PostgreSQL nodes"
}

variable "ami_id" {
  type        = string
  default     = "ami-0c7217cdde317cfec"
  description = "Ubuntu 22.04 LTS - us-east-1"
}

variable "key_name" {
  type        = string
  default     = "postgres-key"
  description = "AWS Key Pair name"
}

variable "my_ip" {
  type        = string
  default     = "0.0.0.0/0"
  description = "Your public IP for SSH - restrict in production"
}

variable "backup_bucket_name" {
  type        = string
  default     = "postgres-backup-us-east-1-99999999"
  description = "S3 bucket name for PostgreSQL backups"
}