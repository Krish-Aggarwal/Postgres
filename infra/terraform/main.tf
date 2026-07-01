module "vpc" {
  source                = "./modules/vpc"
  aws_region            = var.aws_region
  vpc_cidr              = var.vpc_cidr
  public_subnet_cidr    = var.public_subnet_cidr
  private_subnet_1_cidr = var.private_subnet_1_cidr
  private_subnet_2_cidr = var.private_subnet_2_cidr
  private_subnet_3_cidr = var.private_subnet_3_cidr
}

module "security_group" {
  source = "./modules/security_group"
  vpc_id = module.vpc.vpc_id
  my_ip  = var.my_ip
}

module "iam" {
  source            = "./modules/iam"
  backup_bucket_arn = module.s3.bucket_arn
}

module "s3" {
  source      = "./modules/s3"
  bucket_name = var.backup_bucket_name
}

module "ec2" {
  source              = "./modules/ec2"
  ami_id              = var.ami_id
  instance_type       = var.instance_type
  key_name            = var.key_name
  public_subnet_id    = module.vpc.public_subnet_id
  private_subnet_1_id = module.vpc.private_subnet_1_id
  private_subnet_2_id = module.vpc.private_subnet_2_id
  private_subnet_3_id = module.vpc.private_subnet_3_id
  security_group_id   = module.security_group.postgres_sg_id
  iam_profile_name    = module.iam.instance_profile_name
}

resource "local_file" "inventory" {
  content = <<-EOF
[bastion_nodes]
bastion ansible_host=${module.ec2.bastion_public_ip} ansible_user=ubuntu

[primary_nodes]
primary ansible_host=${module.ec2.primary_private_ip} ansible_user=ubuntu

[sync_standby_nodes]
sync_standby ansible_host=${module.ec2.sync_standby_private_ip} ansible_user=ubuntu

[async_standby_nodes]
async_standby ansible_host=${module.ec2.async_standby_private_ip} ansible_user=ubuntu

[standby:children]
sync_standby_nodes
async_standby_nodes

[all:vars]
ansible_user=ubuntu
ansible_ssh_private_key_file=/var/lib/jenkins/workspace/Postgresql-3az@tmp/private_key.key
ansible_ssh_common_args='-o StrictHostKeyChecking=no'

[bastion_nodes:vars]
ansible_ssh_common_args='-o StrictHostKeyChecking=no'

[primary_nodes:vars]
ansible_ssh_common_args='-o StrictHostKeyChecking=no -o ProxyJump=ubuntu@${module.ec2.bastion_public_ip}'

[sync_standby_nodes:vars]
ansible_ssh_common_args='-o StrictHostKeyChecking=no -o ProxyJump=ubuntu@${module.ec2.bastion_public_ip}'

[async_standby_nodes:vars]
ansible_ssh_common_args='-o StrictHostKeyChecking=no -o ProxyJump=ubuntu@${module.ec2.bastion_public_ip}'
EOF

  filename = "${path.module}/../ansible/inventory.ini"
}
