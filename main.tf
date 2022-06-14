// Informer les information de connection avec la région
provider "aws" {
    region = var.AWS_REGION
    access_key = var.AWS_ACCESS_KEY
    secret_key = var.AWS_SECRET_KEY 
}


// Création de l'instance avec ces configuration
resource "aws_instance" "guenoux_ec2_instance"{
    ami = data.aws_ami.ubuntu-ami.id
    instance_type = tolist(data.aws_ec2_instance_types.ami_instance.instance_types)[0]
    vpc_security_group_ids = [aws_security_group.instance_sg.id]
    key_name = aws_key_pair.mykey.key_name
    user_data = <<-EOF
		#!/bin/bash
        sudo apt-get update
		sudo apt-get install -y apache2
		sudo systemctl start apache2
		sudo systemctl enable apache2
		sudo echo "<h1>Hello world</h1>" > /var/www/html/index.html
	EOF
    
    tags = {
        Name = "terraform TP guenoux"
    }
}

// Création ou récupération du groupe de sécurité avec les configuration de connection ouverture de port pour le SSH et html
resource "aws_security_group" "instance_sg" {
    name = "terraform-tp-sg-guenoux"

    egress {
        from_port       = 0
        to_port         = 0
        protocol        = "-1"
        cidr_blocks     = ["0.0.0.0/0"]
    }

    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

// Information de la clé SSH de connection
resource "aws_key_pair" "mykey" {
    key_name = "key-guenoux"
    public_key = var.SSH_PUB_KEY
}


// récuperrer l'adresse IP de l'instance
output "adresse_ip_instance" {
  value = aws_instance.my_ec2_instance.public_ip
}


// Utilisation des Image AMI
data "aws_ami" "ubuntu-ami"{
    owners = ["099720109477"]
    most_recent = true
    
    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-20200408"]
    }
}

// Définir qu'elle type d'instance lors de la crétion de cette dernière
data "aws_ec2_instance_types" "ami_instance" {
    filter {
      name = "processor-info.supported-architecture"
      values = [data.aws_ami.ubuntu-ami.architecture]
    }
}

// Utilisation d'un Bucket s3
module "website_s3_bucket" {
    source = "./modules/aws-s3-static-website-bucket"
    bucket_name = "guenoux-terraform-module"
}