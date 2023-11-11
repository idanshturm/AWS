resource "aws_launch_template" "WP_ASG_Launch_Template" {
  name = "WPASGLaunchTemplate"
  image_id = var.asg_ami
  instance_type   = "t2.micro"
  key_name        = "keypairaz221"
  vpc_security_group_ids = var.asg_ec2_sg

    tags = {
    Name = "WP-ASG-Launch-Template"
  }

    user_data = base64encode(<<-EOF
              #!/bin/bash
              sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport ${var.ec2_efs_dns_name}:/ /var/www/html
              sudo bash -c 'cat <<EOF > /etc/apache2/sites-available/000-default.conf
              <VirtualHost *:80>
                  DocumentRoot /var/www/html
                  <Directory /var/www/html>
                      Options FollowSymLinks
                      AllowOverride Limit Options FileInfo
                      DirectoryIndex index.php
                      Require all granted
                  </Directory>
                  <Directory /var/www/html/wp-content>
                      Options FollowSymLinks
                      Require all granted
                  </Directory>
              </VirtualHost>
              # vim: syntax=apache ts=4 sw=4 sts=4 sr noet
              EOF'

              cd /etc/apache2/sites-available
              sudo a2ensite 000-default
              sudo systemctl reload apache2
              sudo systemctl restart apache2
              EOF
)


}

resource "aws_autoscaling_group" "WP_ASG" {
name =  "wpasg"
max_size = 1
min_size = 1
launch_template {
id = aws_launch_template.WP_ASG_Launch_Template.id
}
vpc_zone_identifier = var.ASG_Subnet_Group_IDS
target_group_arns = var.ASG_Arn_ID
}
