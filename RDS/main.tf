# RDS 생성
resource "aws_db_parameter_group" "mini-db-pg" {
  name = "mini-db-pg"
  description = "mini parameter group"
  family = "mysql8.0"
}

# 옵션 그룹 생성
resource "aws_db_option_group" "mini-db-og" {
  name = "mini-db-og"
  option_group_description = "mini option group"
  engine_name = "mysql"
  major_engine_version = "8.0"
}

# 서브넷 그룹 생성
resource "aws_db_subnet_group" "mini-db-sg" {
  name = "mini-db-sg"
  description = "mini subnet group"
  subnet_ids = [
    var.subnet_id_db1,
    var.subnet_id_db2
  ]
}

# DB 인스턴스 생성
resource "aws_db_instance" "mini-db-instance" {
  identifier = "mini-db"
  engine = "mysql"
  engine_version = "8.0.35"
  instance_class = "db.t3.micro"
  username = "admin"
  password = "admin1234"
  skip_final_snapshot = true
  allocated_storage = 20
  backup_retention_period = 7
  availability_zone = "ap-northeast-2a"

  db_subnet_group_name = aws_db_subnet_group.mini-db-sg.name
  parameter_group_name = aws_db_parameter_group.mini-db-pg.name
  option_group_name = aws_db_option_group.mini-db-og.name
  vpc_security_group_ids = [ var.mini-sg-db ]
}

# DB 레플리카 생성
resource "aws_db_instance" "mini-db-instance-replica" {
  identifier = "mini-db-replica"
  engine = "mysql"
  engine_version = "8.0.35"
  instance_class = "db.t3.micro"
  skip_final_snapshot = true
  parameter_group_name = aws_db_parameter_group.mini-db-pg.name
  option_group_name = aws_db_option_group.mini-db-og.name
  vpc_security_group_ids = [ var.mini-sg-db ]
  availability_zone = "ap-northeast-2c"

  replicate_source_db = aws_db_instance.mini-db-instance.identifier
}
