# AWS
This project is written in Terraform on AWS environment.
The project contains several services whose purpose is to allow access from any IP address to a Wordpress website embedded on EC2 in private subnets.
The project contains the following services:
1. VPC
2. Intrenet Gateways
3. 2 availability zone
4. 6 Subnets.
5. 2 Nat Gateways
6. 2 Elastic IP
7. 4 EC2
8. ALB
9. ASG
10. EFS
11. RDS

The project is built in Structure Module configuration, but most of the resources are built in their folders normally.
A picture of the project architecture is attached.

Some important things to note:
1. Any use of Key Pairs that are currently in the project are mine, so you must replace them with yours, or create new ones.
2. The use of Route 53 is conditional on buying a domain and this must be taken into account.
In addition, after buying the domain, you must manually (after performing terraform apply) change the name servers in the record found in the Hosted Zone to the name servers you received with the domain.
3. To start the project you must install VS Code and within it the Terraform feature of hashicorp, and install the AWS package in your terminal that will give you the option to insert your Access Keys into the terminal and then every time you run Terraform commands you will automatically have access to your environment.

    
   
