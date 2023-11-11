resource "aws_security_group" "WP_RDS_SG" {
  name        = "WP-RDS-SG"
  vpc_id  = var.vpc_id
    tags = {
    Name = "WP-RDS-SG"
  }

  ingress {
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    cidr_blocks = ["172.16.0.96/28", "172.16.0.128/28"]
  }
    egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" 
    cidr_blocks = ["0.0.0.0/0"]
    }

}

resource "aws_security_group" "WP_EFS_SG" {
  name        = "WP-EFS-SG"
  vpc_id  = var.vpc_id
    tags = {
    Name = "WP-EFS-SG"
  }

  ingress {
    from_port        = 2049
    to_port          = 2049
    protocol         = "tcp"
    cidr_blocks = ["172.16.0.96/28", "172.16.0.128/28"]
  }

    egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" 
    cidr_blocks = ["0.0.0.0/0"]
    }

}

resource "aws_security_group" "Bastion_Host_SG" {
  name        = "Bastion-Host-SG"
  vpc_id  = var.vpc_id
    tags = {
    Name = "Bastion-Host-SG"
  }

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks = ["85.250.79.86/32"]
  }

    egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" 
    cidr_blocks = ["0.0.0.0/0"]
    }

}

resource "aws_security_group" "WP_APP_SG" {
  name        = "WP-APP-SG"
  vpc_id  = var.vpc_id
    tags = {
    Name = "WP-APP-SG"
  }

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    security_groups = [aws_security_group.Bastion_Host_SG.id]
  }

 ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    security_groups = [aws_security_group.WP_ALB_SG.id]
  }

   ingress {
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    security_groups = [aws_security_group.WP_ALB_SG.id]
  }

    egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" 
    cidr_blocks = ["0.0.0.0/0"]
    }

}

resource "aws_security_group" "WP_ALB_SG" {
  name        = "WP-ALB-SG"
  vpc_id  = var.vpc_id
    tags = {
    Name = "WP-ALB-SG"
  }

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

    ingress {
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
    egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" 
    cidr_blocks = ["0.0.0.0/0"]
    }

}