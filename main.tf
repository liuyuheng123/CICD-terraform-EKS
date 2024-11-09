module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "jenkins_vpc"
  cidr = var.vpc_cidr

  azs                     = data.aws_availability_zones.azs.names
  public_subnets          = var.public_subnets
  enable_dns_hostnames    = true
  map_public_ip_on_launch = true

  tags = {
    Name        = "jenkins_vpc"
    Terraform   = "true"
    Environment = "dev"
  }

  public_subnet_tags = {
    Name = "jenkins_subnet"
  }
}

# security group -------------------------------------
module "sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.2.0"

  name        = "jenkins_sg"
  description = "Security Group desc"
  vpc_id      = module.vpc.vpc_id

#   ingress_with_cidr_blocks = [
#     {
#       from_port   = 8080
#       to_port     = 8080
#       protocal    = "tcp"
#       description = "HTTP"
#       cidr_block  = "0.0.0.0/0"
#     },
#     {
#       from_port   = 22
#       to_port     = 22
#       protocal    = "tcp"
#       description = "SSH"
#       cidr_block  = "0.0.0.0/0"
#     }
#   ]

#   egress_with_cidr_blocks = [
#     {
#       from_port  = 0
#       to_port    = 0
#       protocal   = "-1"
#       cidr_block = "0.0.0.0/0"
#     }
#   ]

  tags = {
    Name = "jenkins_sg"
  }
}

# ec2 ------------------------------------------
module "ec2-instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.7.1"

  name = "jenkins_server"

  instance_type = var.instance_type
  key_name = "my-new-key"
#   monitoring = true
  vpc_security_group_ids = [module.sg.security_group_id]
  subnet_id = module.vpc.public_subnets[0]

  ami = data.aws_ami.example.name

  tags = {
    Name = "jenkins_server"
    Terraform = "true"
    Environment = "dev"
  }
}