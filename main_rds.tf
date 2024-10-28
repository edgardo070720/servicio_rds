
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"  
}



resource "aws_security_group" "rds_sg" {
  name        = "rds_security_group"
  description = "Security group for RDS instance"

  ingress {
    from_port   = 3306        
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_instance" "rds_cloud" {
  identifier        = "rds-instance"
  allocated_storage = 20
  engine            = "mysql"    
  engine_version    = "8.0"      
  instance_class    = "db.t3.micro"
  db_name           = "rdsdb" 
  username          = "admin"     
  password          = "SecurePass123!"  
  parameter_group_name = "default.mysql8.0"
  vpc_security_group_ids = [aws_security_group.rds_sg.id]


  skip_final_snapshot           = true
  publicly_accessible           = true
  multi_az                      = false
  auto_minor_version_upgrade    = true
  backup_retention_period       = 7
  storage_type                  = "gp2"
}


output "rds_endpoint" {
  value = aws_db_instance.rds_cloud.endpoint
}

output "rds_username" {
  value = aws_db_instance.rds_cloud.username
}

output "rds_database_name" {
  value = aws_db_instance.rds_cloud.db_name
}

