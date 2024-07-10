# public-key 내보내기
output "mini-bastion-public-key" {
  value = aws_key_pair.mini-bastion-public-key.key_name
}
output "mini-web-public-key" {
  value = aws_key_pair.mini-bastion-public-key.key_name
}

# EC2 인스턴스 내보내기
output "mini-ec2-bastion1" {
  value = aws_instance.mini-bastion1.id
}
output "mini-ec2-bastion2" {
  value = aws_instance.mini-bastion2.id
}
output "mini-ec2-web1" {
  value = aws_instance.mini-web1.id
}
output "mini-ec2-web2" {
  value = aws_instance.mini-web2.id
}

# 타겟그룹 내보내기
output "mini-tg-bastion" {
  value = aws_lb_target_group.mini-tg-bastion.arn
}
output "mini-tg-web" {
  value = aws_lb_target_group.mini-tg-web.arn
}


# subnet_id 변수(vpc)
variable "subnet_id_bastion1" {
  description = "bastion subnet id"
}
variable "subnet_id_bastion2" {
  description = "bastion subnet id"
}
variable "subnet_id_web1" {
  description = "web subnet id"
}
variable "subnet_id_web2" {
  description = "web subnet id"
}
variable "subnet_id_db1" {
  description = "db subnet id"
}
variable "subnet_id_db2" {
  description = "db subnet id"
}

# 보안정책 변수(vpc)
variable "mini-sg-bastion" {
  description = "security bastion"
}
variable "mini-sg-web" {
  description = "security web"
}
variable "mini-sg-db" {
  description = "security db"
}
variable "mini-sg-elb" {
  description = "security db"
}

# 역활 변수(s3)
variable "mini-iam-instance-profile" {
  description = "iam instance profile"
}

# vpc 변수(vpc)
variable "vpc_id" {
  description = "vpc id"
}
