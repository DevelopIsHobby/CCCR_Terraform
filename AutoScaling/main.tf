
# 오토스케일링 그룹 만들기
# 템플릿 생성
resource "aws_ami_from_instance" "mini-ami-bastion1" {
  name = "mini-bastion1-ami"
  source_instance_id = var.mini-ec2-bastion1
  snapshot_without_reboot = true
}

resource "aws_ami_from_instance" "mini-ami-bastion2" {
  name = "mini-bastion2-ami"
  source_instance_id = var.mini-ec2-bastion2
  snapshot_without_reboot = true
}

resource "aws_ami_from_instance" "mini-ami-web1" {
  name = "mini-web1-ami"
  source_instance_id = var.mini-ec2-web1
  snapshot_without_reboot = true
}

resource "aws_ami_from_instance" "mini-ami-web2" {
  name = "mini-web2-ami"
  source_instance_id = var.mini-ec2-web2
  snapshot_without_reboot = true
}

# 시작 템플릿 생성
resource "aws_launch_template" "mini-lt-bastion1" {
  name = "mini-bastion1-lt"
  image_id = aws_ami_from_instance.mini-ami-bastion1.id
  instance_type = "t2.micro"

  key_name = var.mini-bastion-public-key
  
  network_interfaces {
    associate_public_ip_address = false
    security_groups = [ var.mini-sg-bastion ]
    subnet_id = var.subnet_id_bastion1
  }
}

resource "aws_launch_template" "mini-lt-bastion2" {
  name = "mini-bastion2-lt"
  image_id = aws_ami_from_instance.mini-ami-bastion2.id
  instance_type = "t2.micro"

  key_name = var.mini-bastion-public-key
  
  network_interfaces {
    associate_public_ip_address = false
    security_groups = [ var.mini-sg-bastion ]
    subnet_id = var.subnet_id_bastion2
  }
}

resource "aws_launch_template" "mini-lt-web1" {
  name = "mini-web1-lt"
  image_id = aws_ami_from_instance.mini-ami-web1.id
  instance_type = "t2.micro"

  key_name = var.mini-web-public-key
  
  network_interfaces {
    associate_public_ip_address = false
    security_groups = [ var.mini-sg-web ]
    subnet_id = var.subnet_id_web1
  }
}

resource "aws_launch_template" "mini-lt-web2" {
  name = "mini-web2-lt"
  image_id = aws_ami_from_instance.mini-ami-web2.id
  instance_type = "t2.micro"

  key_name = var.mini-web-public-key
  
  network_interfaces {
    associate_public_ip_address = false
    security_groups = [ var.mini-sg-web ]
    subnet_id = var.subnet_id_web2
  }
}


# 오토스케일링 그룹 생성
resource "aws_autoscaling_group" "mini-ag-bastion1" {
  name = "mini-ag-bastion1"
  launch_template {
    id = aws_launch_template.mini-lt-bastion1.id
    version = "$Latest"
  }
  vpc_zone_identifier = [
    var.subnet_id_bastion1
  ]

  min_size = 1
  max_size = 2
  desired_capacity = 1
  target_group_arns = [ var.mini-tg-bastion ]
}

resource "aws_autoscaling_group" "mini-ag-bastion2" {
  name = "mini-ag-bastion2"
  launch_template {
    id = aws_launch_template.mini-lt-bastion2.id
    version = "$Latest"
  }
  vpc_zone_identifier = [
    var.subnet_id_bastion2
  ]

  min_size = 1
  max_size = 2
  desired_capacity = 1
  target_group_arns = [ var.mini-tg-bastion ]
}

resource "aws_autoscaling_group" "mini-ag-web1" {
  name = "mini-ag-web1"
  launch_template {
    id = aws_launch_template.mini-lt-web1.id
    version = "$Latest"
  }
  vpc_zone_identifier = [
    var.subnet_id_web1
  ]

  min_size = 1
  max_size = 2
  desired_capacity = 1
  target_group_arns = [ var.mini-tg-web ]
}
resource "aws_autoscaling_group" "mini-ag-web2" {
  name = "mini-ag-web2"
  launch_template {
    id = aws_launch_template.mini-lt-web2.id
    version = "$Latest"
  }
  vpc_zone_identifier = [
    var.subnet_id_web2
  ]

  min_size = 1
  max_size = 2
  desired_capacity = 1
  target_group_arns = [ var.mini-tg-web ]
}

# 오토스케일링 정책 설정
resource "aws_autoscaling_policy" "mini-ap-bastion1" {
  name = "mini-ap-bastion1"
  policy_type = "TargetTrackingScaling"
  estimated_instance_warmup = 300
  autoscaling_group_name = aws_autoscaling_group.mini-ag-bastion1.name

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 50.0
  }
}

resource "aws_autoscaling_policy" "mini-ap-bastion2" {
  name = "mini-ap-bastion2"
  policy_type = "TargetTrackingScaling"
  estimated_instance_warmup = 300
  autoscaling_group_name = aws_autoscaling_group.mini-ag-bastion2.name

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 50.0
  }
}
resource "aws_autoscaling_policy" "mini-ap-web1" {
  name = "mini-ap-web1"
  policy_type = "TargetTrackingScaling"
  estimated_instance_warmup = 300
  autoscaling_group_name = aws_autoscaling_group.mini-ag-web1.name

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 50.0
  }
}
resource "aws_autoscaling_policy" "mini-ap-web2" {
  name = "mini-ap-web2"
  policy_type = "TargetTrackingScaling"
  estimated_instance_warmup = 300
  autoscaling_group_name = aws_autoscaling_group.mini-ag-web2.name

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 50.0
  }
}
