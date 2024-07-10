# EC2 인스턴스 가져오기(ec2)
variable "mini-ec2-bastion1" {
  description = "bastion1 EC2"
}
variable "mini-ec2-bastion2" {
  description = "bastion2 EC2"
}
variable "mini-ec2-web1" {
  description = "web1 EC2"
}
variable "mini-ec2-web2" {
  description = "web2 EC2"
}

# EC2 공개키 가져오기(ec2)
variable "mini-bastion-public-key" {
  description = "bastion public key"
}
variable "mini-web-public-key" {
  description = "web public key"
}

# 타겟그룹 가져오기(ec2)
variable "mini-tg-bastion" {
  description = "bastion ELB TG"
}
variable "mini-tg-web" {
  description = "web ELB TG"
}

# subnet_id 가져오기(vpc)
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

# 보안정책 가져오기(vpc)
variable "mini-sg-bastion" {
  description = "security bastion"
}
variable "mini-sg-web" {
  description = "security web"
}
