output "bastion_public_ip" {
  value       = module.ec2.bastion_public_ip
  description = "Bastion public IP"
}

output "primary_private_ip" {
  value       = module.ec2.primary_private_ip
  description = "Primary PostgreSQL private IP"
}

output "sync_standby_private_ip" {
  value       = module.ec2.sync_standby_private_ip
  description = "Sync standby private IP - AZ-b"
}

output "async_standby_private_ip" {
  value       = module.ec2.async_standby_private_ip
  description = "Async standby private IP - AZ-c"
}

output "backup_bucket" {
  value       = module.s3.bucket_name
  description = "S3 backup bucket name"
}

output "bastion_instance_id" {
  value = module.ec2.bastion_instance_id
}

output "primary_instance_id" {
  value = module.ec2.primary_instance_id
}

output "sync_standby_instance_id" {
  value = module.ec2.sync_standby_instance_id
}

output "async_standby_instance_id" {
  value = module.ec2.async_standby_instance_id
}