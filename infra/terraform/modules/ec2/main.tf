# Bastion - public AZ-a
resource "aws_instance" "bastion" {
  ami                    = var.ami_id
  instance_type          = "t3.micro"
  subnet_id              = var.public_subnet_id
  key_name               = var.key_name
  vpc_security_group_ids = [var.security_group_id]
  iam_instance_profile   = var.iam_profile_name
  tags = { Name = "bastion" }
}

# Primary - private AZ-a
resource "aws_instance" "primary" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.private_subnet_1_id
  key_name               = var.key_name
  vpc_security_group_ids = [var.security_group_id]
  iam_instance_profile   = var.iam_profile_name
  tags = { Name = "postgres-primary" }
}

# Sync standby - private AZ-b
resource "aws_instance" "sync_standby" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.private_subnet_2_id
  key_name               = var.key_name
  vpc_security_group_ids = [var.security_group_id]
  iam_instance_profile   = var.iam_profile_name
  tags = { Name = "postgres-sync-standby" }
}

# Async standby - private AZ-c
resource "aws_instance" "async_standby" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.private_subnet_3_id
  key_name               = var.key_name
  vpc_security_group_ids = [var.security_group_id]
  iam_instance_profile   = var.iam_profile_name
  tags = { Name = "postgres-async-standby" }
}