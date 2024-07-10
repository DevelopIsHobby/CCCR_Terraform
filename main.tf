module "vpc" {
  source = "./vpc"
}

module "ec2" {
  source = "./ec2"
  vpc_id = module.vpc.vpc_id
  subnet_id_bastion1 = module.vpc.subnet_id_bastion1
  subnet_id_bastion2 = module.vpc.subnet_id_bastion2
  subnet_id_web1 = module.vpc.subnet_id_web1
  subnet_id_web2 = module.vpc.subnet_id_web2
  subnet_id_db1 = module.vpc.subnet_id_db1
  subnet_id_db2 = module.vpc.subnet_id_db2
  mini-sg-bastion = module.vpc.mini-sg-bastion
  mini-sg-web = module.vpc.mini-sg-web
  mini-sg-db = module.vpc.mini-sg-db
  mini-sg-elb = module.vpc.mini-sg-elb
  mini-iam-instance-profile = module.s3.mini-iam-instance-profile
}

module "rds" {
  source = "./rds"
  subnet_id_db1 = module.vpc.subnet_id_db1
  subnet_id_db2 = module.vpc.subnet_id_db2
  mini-sg-db = module.vpc.mini-sg-db
}

module "s3" {
  source = "./s3"
}

module "autoScaling" {
  source = "./autoScaling"
  mini-ec2-bastion1 = module.ec2.mini-ec2-bastion1
  mini-ec2-bastion2 = module.ec2.mini-ec2-bastion2
  mini-ec2-web1 = module.ec2.mini-ec2-web1
  mini-ec2-web2 = module.ec2.mini-ec2-web2
  mini-bastion-public-key = module.ec2.mini-bastion-public-key
  mini-web-public-key = module.ec2.mini-web-public-key
  subnet_id_bastion1 = module.vpc.subnet_id_bastion1
  subnet_id_bastion2 = module.vpc.subnet_id_bastion2
  subnet_id_web1 = module.vpc.subnet_id_web1
  subnet_id_web2 = module.vpc.subnet_id_web2
  mini-sg-bastion = module.vpc.mini-sg-bastion
  mini-sg-web = module.vpc.mini-sg-web
  mini-tg-bastion = module.ec2.mini-tg-bastion
  mini-tg-web = module.ec2.mini-tg-web
}
