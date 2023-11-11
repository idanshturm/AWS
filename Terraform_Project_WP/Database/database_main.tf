resource "aws_db_subnet_group" "WP_RDS_SubnetGroup" {
  name       = "wp_rds_subnet_group"
  subnet_ids = var.DB_Subnet_Group_IDS
  tags = {
    Name = "WP-RDS-SubnetGroup"
  }
}

resource "random_password" "WP_RDS_password" {
  length  = 10
  special = true
  override_special = "_%@"
}



resource "aws_db_instance" "WP_RDS_MySQL" {

  engine                      = "mysql"
  engine_version              = "8.0.33"
  multi_az                    = true
  identifier                  = "wprdsmysql"
  username                    = "SQLadmin"
  password                    = random_password.WP_RDS_password.result
  instance_class              = "db.t3.micro"
  allocated_storage           = 20
  storage_type                = "gp2"
  db_subnet_group_name        = aws_db_subnet_group.WP_RDS_SubnetGroup.name
  vpc_security_group_ids      = var.vpc_security_group_ids
  publicly_accessible         = false
  backup_retention_period     = 0  
  storage_encrypted           = true
  skip_final_snapshot         = true

  tags = {
    Name = "WP_RDS_MySQL"
    Environment = "Free tier"
  }
}

resource "aws_efs_file_system" "WP_EFS" {

  encrypted  = false
  tags = {
    Name = "WP-EFS" 
  }
  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS" 
  }
}

resource "aws_efs_mount_target" "WP_EFS_Mount_Target_AZ1" {

  file_system_id  = aws_efs_file_system.WP_EFS.id
  subnet_id       = var.efs_subnet_id_az1 
  security_groups = var.efs_SG
}

resource "aws_efs_mount_target" "WP_EFS_Mount_Target_AZ2" {

  file_system_id  = aws_efs_file_system.WP_EFS.id
  subnet_id       = var.efs_subnet_id_az2
  security_groups = var.efs_SG 
}