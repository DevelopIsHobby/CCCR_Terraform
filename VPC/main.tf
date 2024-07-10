provider "aws" {
  region = "ap-northeast-2"
}

# VPC 생성
resource "aws_vpc" "terraform-vpc" {
  cidr_block = "192.168.0.0/16"
  tags = {
    Name = "mini-vpc"
  }
}

# 서브넷 생성
resource "aws_subnet" "terraform-public-bastion1" {
  vpc_id = aws_vpc.terraform-vpc.id

  availability_zone = "ap-northeast-2a"
  cidr_block = "192.168.0.0/24"

  tags = {
    Name = "mini-public-bastion1"
  }
}

resource "aws_subnet" "terraform-public-bastion2" {
  vpc_id = aws_vpc.terraform-vpc.id

  availability_zone = "ap-northeast-2c"
  cidr_block = "192.168.1.0/24"

  tags = {
    Name = "mini-public-bastion2"
  }
}


resource "aws_subnet" "terraform-private-web1" {
  vpc_id = aws_vpc.terraform-vpc.id

  availability_zone = "ap-northeast-2a"
  cidr_block = "192.168.2.0/24"

  tags = {
    Name = "mini-private-web1"
  }
}

resource "aws_subnet" "terraform-private-web2" {
  vpc_id = aws_vpc.terraform-vpc.id

  availability_zone = "ap-northeast-2c"
  cidr_block = "192.168.3.0/24"

  tags = {
    Name = "mini-private-web2"
  }
}

resource "aws_subnet" "terraform-private-db1" {
  vpc_id = aws_vpc.terraform-vpc.id

  availability_zone = "ap-northeast-2a"
  cidr_block = "192.168.4.0/24"

  tags = {
    Name = "mini-private-db1"
  }
}

resource "aws_subnet" "terraform-private-db2" {
  vpc_id = aws_vpc.terraform-vpc.id

  availability_zone = "ap-northeast-2c"
  cidr_block = "192.168.5.0/24"

  tags = {
    Name = "mini-private-db2"
  }
}

# 인터넷 게이트웨이 생성
resource "aws_internet_gateway" "terraform-igw" {
  vpc_id = aws_vpc.terraform-vpc.id
 
  tags = {
    Name = "mini-igw"
  }
}

# 탄력적 IP 주소 생성
# 기존의 탄력적 IP를 지우고 새롭게 생성
resource "aws_eip" "terraform-eip01" {
  domain = "vpc"
  lifecycle {
    create_before_destroy = true
  }

}

resource "aws_eip" "terraform-eip02" {
  domain = "vpc"
  lifecycle {
  create_before_destroy = true
  }
}

# NAT 게이트웨이 생성(퍼블릭 서브넷 용 - 탄력적 ip 부여)
resource "aws_nat_gateway" "terraform-ngw01" {
  allocation_id = aws_eip.terraform-eip01.id
  
  subnet_id = aws_subnet.terraform-public-bastion1.id

  tags = {
    Name = "mini-ngw01"
  }
}

resource "aws_nat_gateway" "terraform-ngw02" {
  allocation_id = aws_eip.terraform-eip02.id
  
  subnet_id = aws_subnet.terraform-public-bastion2.id

  tags = {
    Name = "mini-ngw02"
  }
}

# 퍼블릭 서브넷용  라우팅 테이블 생성(인터넷 게이트웨이와 연결)
resource "aws_route_table" "terraform-rt-public" {
  vpc_id = aws_vpc.terraform-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    
    gateway_id = aws_internet_gateway.terraform-igw.id
  }
  
  tags = {
    Name = "mini-rt-public"
  }
}


# 퍼블릭 서브넷을 라우팅 테이블에 등록(인터넷게이트웨이와 퍼블릭 서브넷 연결)
resource "aws_route_table_association" "terraform-aws-route-table-association-public01" {
  subnet_id = aws_subnet.terraform-public-bastion1.id
  route_table_id = aws_route_table.terraform-rt-public.id
}

resource "aws_route_table_association" "terraform-aws-route-table-association-public02" {
  subnet_id = aws_subnet.terraform-public-bastion2.id
  route_table_id = aws_route_table.terraform-rt-public.id
}

# 프라이빗 서브넷용 라우팅 테이블 생성(퍼블릿 서브넷1,2의 NAT 게이트웨이와 연결)
resource "aws_route_table" "terraform-rt-private01" {
  vpc_id = aws_vpc.terraform-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
   
    nat_gateway_id = aws_nat_gateway.terraform-ngw01.id
  }
  
  tags = {
    Name = "mini-rt-web1"
  }
}

resource "aws_route_table" "terraform-rt-private02" {
  vpc_id = aws_vpc.terraform-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
   
    nat_gateway_id = aws_nat_gateway.terraform-ngw02.id
  }
  
  tags = {
    Name = "mini-rt-web2"
  }
}

resource "aws_route_table" "terraform-rt-private03" {
  vpc_id = aws_vpc.terraform-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
   
    nat_gateway_id = aws_nat_gateway.terraform-ngw01.id
  }
  
  tags = {
    Name = "mini-rt-db1"
  }
}

resource "aws_route_table" "terraform-rt-private04" {
  vpc_id = aws_vpc.terraform-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
   
    nat_gateway_id = aws_nat_gateway.terraform-ngw02.id
  }
  
  tags = {
    Name = "mini-rt-db2"
  }
}

# 프라이빗 서브넷을 라우팅 테이블에 등록
resource "aws_route_table_association" "terraform-aws-route-table-association-private01" {
  subnet_id = aws_subnet.terraform-private-web1.id

  route_table_id = aws_route_table.terraform-rt-private01.id
}

resource "aws_route_table_association" "terraform-aws-route-table-association-private02" {
  subnet_id = aws_subnet.terraform-private-web2.id

  route_table_id = aws_route_table.terraform-rt-private02.id
}

resource "aws_route_table_association" "terraform-aws-route-table-association-private03" {
  subnet_id = aws_subnet.terraform-private-db1.id

  route_table_id = aws_route_table.terraform-rt-private03.id
}

resource "aws_route_table_association" "terraform-aws-route-table-association-private04" {
  subnet_id = aws_subnet.terraform-private-db2.id

  route_table_id = aws_route_table.terraform-rt-private04.id
}

# 보안 그룹 설정 - bastion 
resource "aws_security_group" "terraform-sg-bastion" {
  name = "sample-sg-bastion"
  vpc_id = aws_vpc.terraform-vpc.id

  ingress {
    from_port = 22
    to_port = 22                // from, to가 같으면 포트 개방을 의미
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  // blocks는 배열이기 때문에 [] 추가
    ipv6_cidr_blocks = ["::/0"]
  }
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  egress {
    from_port = 0     // 모든 포트 개방
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

# 보안 그룹 설정 - web
resource "aws_security_group" "terraform-sg-web" {
  name = "sample-sg-web"
  vpc_id = aws_vpc.terraform-vpc.id

  ingress {
    from_port = 22
    to_port = 22                // from, to가 같으면 포트 개방을 의미
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  // blocks는 배열이기 때문에 [] 추가
    ipv6_cidr_blocks = ["::/0"]
  }
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  egress {
    from_port = 0     // 모든 포트 개방
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

# 보안 그룹 설정 - db
resource "aws_security_group" "terraform-sg-db" {
  name = "sample-sg-db"
  vpc_id = aws_vpc.terraform-vpc.id

  ingress {
    from_port = 22
    to_port = 22                // from, to가 같으면 포트 개방을 의미
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  // blocks는 배열이기 때문에 [] 추가
    ipv6_cidr_blocks = ["::/0"]
  }
  ingress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  egress {
    from_port = 0     // 모든 포트 개방
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

# 보안 그룹 설정 - 로드 밸런서
resource "aws_security_group" "terraform-sg-elb" {
  name = "mini-elb"
  vpc_id = aws_vpc.terraform-vpc.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}
