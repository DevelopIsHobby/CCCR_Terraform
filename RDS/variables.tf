# subnet_id 변수(vpc)
variable "subnet_id_db1" {
  description = "db subnet id"
}
variable "subnet_id_db2" {
  description = "db subnet id"
}

# 보안 정책 변수(vpc)
variable "mini-sg-db" {
  description = "security db"
}
