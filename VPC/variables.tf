# vpc_id 내보내기
output "vpc_id" {
  value = aws_vpc.terraform-vpc.id
}

# subnet_id 내보내기
output "subnet_id_bastion1" {    // vpc.tf에서 subnet_id_bastion1 내보내기
  value = aws_subnet.terraform-public-bastion1.id
}
output "subnet_id_bastion2" {
  value = aws_subnet.terraform-public-bastion2.id
}
output "subnet_id_web1" {
  value = aws_subnet.terraform-private-web1.id
}
output "subnet_id_web2" {
  value = aws_subnet.terraform-private-web2.id
}
output "subnet_id_db1" {
  value = aws_subnet.terraform-private-db1.id
}
output "subnet_id_db2" {
  value = aws_subnet.terraform-private-db2.id
}

# 보안그룹 내보내기
output "mini-sg-bastion" {
  value = aws_security_group.terraform-sg-bastion.id
}
output "mini-sg-web" {
  value = aws_security_group.terraform-sg-web.id
}
output "mini-sg-db" {
  value = aws_security_group.terraform-sg-db.id
}
output "mini-sg-elb" {
  value = aws_security_group.terraform-sg-elb.id
}
