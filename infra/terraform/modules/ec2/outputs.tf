output "bastion_public_ip"        { value = aws_instance.bastion.public_ip }
output "primary_private_ip"       { value = aws_instance.primary.private_ip }
output "sync_standby_private_ip"  { value = aws_instance.sync_standby.private_ip }
output "async_standby_private_ip" { value = aws_instance.async_standby.private_ip }
output "bastion_instance_id"      { value = aws_instance.bastion.id }
output "primary_instance_id"      { value = aws_instance.primary.id }
output "sync_standby_instance_id" { value = aws_instance.sync_standby.id }
output "async_standby_instance_id" { value = aws_instance.async_standby.id }