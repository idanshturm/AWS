resource "aws_instance" "WP_EC2_bastion_host" {
  ami             = "ami-0fc5d935ebf8bc3bc"
  instance_type   = "t2.micro"
  key_name        = "WP-KeyPair"
  subnet_id       = var.ec2_public_subnet_id_az1
  vpc_security_group_ids = var.ec2_bastion_host_SG
  associate_public_ip_address = true

  root_block_device {
    volume_size = 20
    volume_type = "gp2"
    delete_on_termination = true
  }

  tags = {
    Name = "WP-EC2-bastion-host"
  }
}

resource "aws_instance" "WP_EC2_APP_AZ1" {
  ami             = "ami-0fc5d935ebf8bc3bc"
  instance_type   = "t2.micro"
  key_name        = "keypair-az1"
  subnet_id       = var.ec2_private_subnet_APP_id_az1
  vpc_security_group_ids = var.ec2_private_subnet_APP_SG_az1
  associate_public_ip_address = false

  root_block_device {
    volume_size = 20
    volume_type = "gp2"
    delete_on_termination = true
  }

  user_data = <<-EOF
              #!/bin/bash
              sudo -i
              sudo apt-get update
              sudo apt-get upgrade -y
              sudo apt-get install -y nfs-common
              sudo mkdir -p /var/www/html
              sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport ${var.ec2_efs_dns_name}:/ /var/www/html
              sudo apt-get update
              sudo apt-get install -y apache2 apache2-utils ssl-cert
              sudo systemctl enable apache2
              sudo systemctl start apache2
              sudo apt-get update
              sudo apt install software-properties-common
              sudo add-apt-repository ppa:ondrej/php
              sudo apt-get update
              sudo apt-get install php7.4 php7.4-common php7.4-cli php-pear -y
              sudo apt-get install php7.4-{cgi,curl,mbstring,gd,mysql,gettext,json,xml,fpm,intl,zip} -y
              sudo apt-get update
              sudo apt-get install mysql-client -y
              sudo apt-get install mysql-server -y
              sudo systemctl enable mysql
              sudo systemctl start mysql
              DB_HOST="${var.ec2_db_endpoint}"
              DB_PASSWORD="${var.ec2_db_password}"
              DB_NAME="MySQL_WP"
              DB_USER="SQLadmin"
              mysql -u SQLadmin -p"$DB_PASSWORD" -h"$DB_HOST" -e "CREATE DATABASE IF NOT EXISTS MySQL_WP;"
              sudo usermod -a -G www-data ubuntu
              sudo chown -R ubuntu:www-data /var/www
              sudo find /var/www -type d -exec chmod 2775 {} \;
              sudo find /var/www -type f -exec chmod 0664 {} \;
              sudo chown www-data:www-data -R /var/www/html
              wget https://wordpress.org/latest.tar.gz
              tar -xzf latest.tar.gz
              sudo cp -r wordpress/* /var/www/html/
              sudo cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
              sudo apt-get update
              sudo apt-get install sed
              sed -i "s/database_name_here/$DB_NAME/" /var/www/html/wp-config.php
              sed -i "s/username_here/$DB_USER/" /var/www/html/wp-config.php
              sed -i "s/password_here/$DB_PASSWORD/" /var/www/html/wp-config.php
              sed -i "s/localhost/$DB_HOST/" /var/www/html/wp-config.php
              cd /home/ubuntu
              curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
              chmod +x wp-cli.phar
              sudo mv wp-cli.phar /usr/local/bin/wp
              cd /var/www/html
              PRIVATE_IP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)
              wp core install --url="http://$PRIVATE_IP" --title="IdanProjectSite" --admin_user="admin" --admin_password="password" --admin_email="idanshturm1@gmail.com" --skip-email --allow-root
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

  tags = {
    Name = "WP-EC2-APP-AZ1"
  }
}

resource "time_sleep" "wait_5_minutes" {
  depends_on = [aws_instance.WP_EC2_APP_AZ1]

  create_duration = "5m"
}

resource "aws_ami_from_instance" "WP_AMI_Instances" {
  depends_on = [time_sleep.wait_5_minutes]
  name               = "wpinstancesami"
  source_instance_id = aws_instance.WP_EC2_APP_AZ1.id
  snapshot_without_reboot = true
   tags = {
    Name = "WP-AMI-Instances"
}

}

resource "aws_instance" "WP_EC2_APP_AZ2" {
  ami             = aws_ami_from_instance.WP_AMI_Instances.id
  instance_type   = "t2.micro"
  key_name        = "keypairaz221"
  subnet_id       = var.ec2_private_subnet_APP_id_az2
  vpc_security_group_ids = var.ec2_private_subnet_APP_SG_az2
  associate_public_ip_address = false

  root_block_device {
    volume_size = 20
    volume_type = "gp2"
    delete_on_termination = true
  }

  tags = {
    Name = "WP-EC2-APP-AZ2"
  }

    user_data = <<-EOF
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

}

