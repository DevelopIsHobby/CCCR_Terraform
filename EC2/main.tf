# 인스턴스 생성
provider "aws" {
  region = "ap-northeast-2"
}

# 키 알고리즘 생성(bastion)
resource "tls_private_key" "mini-key-algorithm-bastion" {
  algorithm = "RSA"
  rsa_bits = 4096
}

# 공개키 생성(bastion)
resource "aws_key_pair" "mini-bastion-public-key" {
  key_name = "mini-bastion-public-key"
  public_key = tls_private_key.mini-key-algorithm-bastion.public_key_openssh
}

# 개인키 생성(bastion, tf 파일 있는 곳에 pem파일 생성)
resource "local_file" "mini-bastion-private-key" {
  filename = "bastion.pem"
  content = tls_private_key.mini-key-algorithm-bastion.private_key_pem
}

# 키 알고리즘 생성(web)
resource "tls_private_key" "mini-key-algorithm-web" {
  algorithm = "RSA"
  rsa_bits = 4096
}

# 공개키 생성(web)
resource "aws_key_pair" "mini-web-public-key" {
  key_name = "mini-web-public-key"
  public_key = tls_private_key.mini-key-algorithm-web.public_key_openssh
}

# 개인키 생성(web)
resource "local_file" "mini-web-private-key" {
  filename = "web.pem"
  content = tls_private_key.mini-key-algorithm-web.private_key_pem
}

# 키 알고리즘 생성(db)
resource "tls_private_key" "mini-key-algorithm-db" {
  algorithm = "RSA"
  rsa_bits = 4096
}

# 공개키 생성(db)
resource "aws_key_pair" "mini-db-public-key" {
  key_name = "mini-db-public-key"
  public_key = tls_private_key.mini-key-algorithm-db.public_key_openssh
}

# 개인키 생성(db)
resource "local_file" "mini-db-private-key" {
  filename = "db.pem"
  content = tls_private_key.mini-key-algorithm-db.private_key_pem
}

# 인스턴스 생성(bastion)
resource "aws_instance" "mini-bastion1" {
  ami = "ami-0edc5427d49d09d2a"
  instance_type = "t2.micro"
  key_name = aws_key_pair.mini-bastion-public-key.key_name
  subnet_id = var.subnet_id_bastion1
  vpc_security_group_ids = [ var.mini-sg-bastion ]
  associate_public_ip_address = true

  tags = {
    Name = "mini-bastion1"
  }
  
  user_data = <<EOF
#!/bin/bash
# Redirect output and errors to /var/log/user-data.log
exec > /var/log/user-data.log 2>&1
set -x

# Update system and install httpd
yum update -y
yum install -y httpd

# Start and enable httpd service
systemctl start httpd
systemctl enable httpd

# Create index.html with desired content
cat <<EOT > /var/www/html/index.html
<html>
<head>
</head>
<body>
    Hello bastion1
</body>
</html>
EOT
EOF
}

resource "aws_instance" "mini-bastion2" {
  ami = "ami-0edc5427d49d09d2a"
  instance_type = "t2.micro"
  key_name = aws_key_pair.mini-bastion-public-key.key_name
  subnet_id = var.subnet_id_bastion2
  vpc_security_group_ids = [ var.mini-sg-bastion ]
  associate_public_ip_address = true

  tags = {
    Name = "mini-bastion2"
  }
  user_data = <<EOF
#!/bin/bash
# Redirect output and errors to /var/log/user-data.log
exec > /var/log/user-data.log 2>&1
set -x

# Update system and install httpd
yum update -y
yum install -y httpd

# Start and enable httpd service
systemctl start httpd
systemctl enable httpd

# Create index.html with desired content
cat <<EOT > /var/www/html/index.html
<html>
<head>
</head>
<body>
    Hello bastion2
</body>
</html>
EOT
EOF
}



# 인스턴스 생성(web01)
resource "aws_instance" "mini-web1" {
  ami = "ami-0edc5427d49d09d2a"
  instance_type = "t2.micro"
  key_name = aws_key_pair.mini-web-public-key.key_name
  subnet_id = var.subnet_id_web1
  vpc_security_group_ids = [ var.mini-sg-web ]  

  tags = {
    Name = "mini-web1"
  }
  user_data = <<EOF
#!/bin/bash
# Redirect output and errors to /var/log/user-data.log
exec > /var/log/user-data.log 2>&1
set -x

# Update system and install httpd
yum update -y
yum install -y httpd

# Start and enable httpd service
systemctl start httpd
systemctl enable httpd

# Create index.html with desired content
cat <<EOT > /var/www/html/index.html
<html>
<head>
</head>
<body>
    Hello web1
</body>
</html>
EOT
EOF
}

# 인스턴스 생성(web02)
resource "aws_instance" "mini-web2" {
  ami = "ami-0edc5427d49d09d2a"
  instance_type = "t2.micro"
  key_name = aws_key_pair.mini-web-public-key.key_name
  subnet_id = var.subnet_id_web2
  vpc_security_group_ids = [ var.mini-sg-web ]  

  tags = {
    Name = "mini-web2"
  }
  user_data = <<EOF
#!/bin/bash
# Redirect output and errors to /var/log/user-data.log
exec > /var/log/user-data.log 2>&1
set -x

# Update system and install httpd
yum update -y
yum install -y httpd

# Start and enable httpd service
systemctl start httpd
systemctl enable httpd

# Create index.html with desired content
cat <<EOT > /var/www/html/index.html
<html>
<head>
</head>
<body>
    Hello web2
</body>
</html>
EOT
EOF
}

# 인스턴스 생성(db1)
resource "aws_instance" "mini-db1" {
  ami = "ami-0edc5427d49d09d2a"
  instance_type = "t2.micro"
  key_name = aws_key_pair.mini-db-public-key.key_name
  subnet_id = var.subnet_id_db1
  vpc_security_group_ids = [ var.mini-sg-db ]  

  iam_instance_profile = var.mini-iam-instance-profile

  tags = {
    Name = "mini-db1"
  }
}

# 인스턴스 생성(db2)
resource "aws_instance" "mini-db2" {
  ami = "ami-0edc5427d49d09d2a"
  instance_type = "t2.micro"
  key_name = aws_key_pair.mini-db-public-key.key_name
  subnet_id = var.subnet_id_db2
  vpc_security_group_ids = [ var.mini-sg-db ]  
  
  iam_instance_profile = var.mini-iam-instance-profile

  tags = {
    Name = "mini-db2"
  }
}

# 로드 밸런서 생성
resource "aws_lb" "mini-elb-bastion" {
  name = "mini-elb-bastion"
  load_balancer_type = "application"
  internal = false
  subnets = [ var.subnet_id_bastion1, var.subnet_id_bastion2 ]
  security_groups = [ var.mini-sg-elb ]
}

resource "aws_lb" "mini-elb-web" {
  name = "mini-elb-web"
  load_balancer_type = "application"
  internal = false
  subnets = [ var.subnet_id_bastion1, var.subnet_id_bastion2 ]
  security_groups = [ var.mini-sg-elb ]
}

# 타겟 그룹 생성
resource "aws_lb_target_group" "mini-tg-bastion" {
  name = "mini-tg-bastion"
  port = 80
  protocol = "HTTP"
  vpc_id = var.vpc_id
  
  health_check {
    path = "/index.html"
    protocol = "HTTP"
    healthy_threshold = 2 
    unhealthy_threshold = 2
    interval = 30
    timeout = 5
    
  }
}

resource "aws_lb_target_group" "mini-tg-web" {
  name = "mini-tg-web"
  port = 80
  protocol = "HTTP"
  vpc_id = var.vpc_id
  
  health_check {
    path = "/index.html"
    protocol = "HTTP"
    healthy_threshold = 2 
    unhealthy_threshold = 2
    interval = 30
    timeout = 5
  }
}

# 리스너 지정
resource "aws_lb_listener" "mini-lb-listener-bastion" {
  load_balancer_arn = aws_lb.mini-elb-bastion.arn
  port = 80
  protocol = "HTTP"
  
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.mini-tg-bastion.arn
  }
}

resource "aws_lb_listener" "mini-lb-listener-web" {
  load_balancer_arn = aws_lb.mini-elb-web.arn
  port = 80
  protocol = "HTTP"
  
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.mini-tg-web.arn
  }
}

# 타겟 그룹 연결(bastion)
resource "aws_lb_target_group_attachment" "mini-target_group_attachment-bastion1" {
  target_group_arn = aws_lb_target_group.mini-tg-bastion.arn
  target_id = aws_instance.mini-bastion1.id
  port = 80
}

resource "aws_lb_target_group_attachment" "mini-target_group_attachment-bastion2" {
  target_group_arn = aws_lb_target_group.mini-tg-bastion.arn
  target_id = aws_instance.mini-bastion2.id
  port = 80
}

resource "aws_lb_target_group_attachment" "mini-target_group_attachment-web1" {
  target_group_arn = aws_lb_target_group.mini-tg-web.arn
  target_id = aws_instance.mini-web1.id
  port = 80
}

resource "aws_lb_target_group_attachment" "mini-target_group_attachment-web2" {
  target_group_arn = aws_lb_target_group.mini-tg-web.arn
  target_id = aws_instance.mini-web2.id
  port = 80
}
