Terraform Configuration for AWS VPC with EC2 Instance
This repository contains a Terraform configuration to set up a basic AWS Virtual Private Cloud (VPC) infrastructure. 
This setup includes an Internet Gateway, Route Table, Subnet, Security Group, EC2 instance with an Elastic IP, and associated networking components. 
The EC2 instance is provisioned with Apache web server installed and serves a simple webpage.

**Prerequisites**

Before applying this configuration, ensure you have the following:
1.	Terraform installed on your machine. You can install Terraform from here.
2.	AWS CLI configured with the appropriate credentials. You can configure it using `aws configure`.
3.	An SSH key pair in your AWS account. The key pair name should match the value of `key_name` in the configuration (`terraformkeypair` in this case). You can create one from the AWS Console under EC2 > Key Pairs.

**Resources**

This Terraform configuration sets up the following resources:
1.	**VPC:** A Virtual Private Cloud (VPC) with a CIDR block of `10.0.0.0/16`.
2.	**Internet Gateway:** Allows the VPC to communicate with the internet.
3.	**Route Table:** Configures routes to allow outbound internet traffic via the Internet Gateway.
4.	**Subnet:** A subnet with a CIDR block of `10.0.1.0/24`, located in `us-east-1a`.
5.	**Security Group:** A security group with the following inbound rules: Allow HTTP (port 80) from anywhere.
   
Allow HTTPS (port 443) from anywhere.

  Allow SSH (port 22) from anywhere.
  
  Allow IPv6 HTTPS (port 443) from anywhere. 
  
  Additionally, outbound traffic is allowed for both IPv4 and IPv6.
  
6.	**Elastic IP (EIP):** An elastic IP address that is associated with the EC2 instance.
7.	**Network Interface:** A network interface attached to the EC2 instance.
8.	**EC2 Instance:** A `t2.micro` EC2 instance using an Amazon Linux AMI, with Apache installed and configured to serve a simple web page.
   
**Configuration**

**1.	Virtual Private Cloud (VPC)****

The VPC resource creates a VPC with a CIDR block of `10.0.0.0/16`.

![image](https://github.com/user-attachments/assets/91ad3333-9c96-46dc-a89c-4157cf9c9e4e)

 
**2.	Internet Gateway**
   
The Internet Gateway allows the VPC to connect to the internet.

![image](https://github.com/user-attachments/assets/83c5b33a-ef9d-46e7-8181-d4204180be93)


**3.	Route Table**

The Route Table includes routes for both IPv4 and IPv6 traffic, directing outbound traffic through the Internet Gateway.

![image](https://github.com/user-attachments/assets/d651e7e1-9620-4cac-9810-d91446224467)

 
**4.	Subnet**
   
This configuration creates a subnet in the `us-east-1a` availability zone.

![image](https://github.com/user-attachments/assets/855a4d3d-b7a0-4562-9565-06f0686398f7)


**5.	Security Group**
   
The security group allows inbound web traffic (HTTP, HTTPS) and SSH, while allowing all outbound traffic.

![image](https://github.com/user-attachments/assets/eb91e04f-b1bf-4250-861f-19b066081c18)


 
**Set Inbound Rules**

•	Allow HTTP (port 80) from anywhere (IPv4).
•	Allow HTTPS (port 443) from anywhere (IPv4 and IPv6). 
•	Allow SSH (port 22) from anywhere 

![image](https://github.com/user-attachments/assets/76b748ce-32ee-40bd-a7ac-c04d399973b5)


**Set Outbound Rules**

Allow all outbound traffic for both IPv4 and IPv6.

![image](https://github.com/user-attachments/assets/db1042f4-d353-492b-8712-049805da3c81)


**6.	Network Interface**
   
This network interface is associated with the subnet and security group.

![image](https://github.com/user-attachments/assets/3f14301a-4e54-4b69-90b3-dd9cdd341f1b)

 
 
**7.	Elastic IP**
   
An Elastic IP is created and associated with the network interface.

![image](https://github.com/user-attachments/assets/da717a86-a842-4b5e-a67e-279a9b5f268a)


**9.	EC2 Instance**
An EC2 instance is created with the network interface attached. Apache is installed and configured to serve a simple web page.

![image](https://github.com/user-attachments/assets/b4260f06-24e3-4699-b148-8b22c13db6f4)




**Usage**

1.	Clone this repository to your local machine.
2.	Initialize Terraform:
   
![image](https://github.com/user-attachments/assets/8fe7e0e2-4c76-492c-b070-995af6404537)


3.	Validate the configuration:
   
![image](https://github.com/user-attachments/assets/ddc02923-bdb8-4bd1-b2c3-34cd6a9cc444)


4.	Apply the configuration:
   
![image](https://github.com/user-attachments/assets/8a264d6d-310f-4418-b503-dd7918af863d)


5.	Confirm the changes, and Terraform will begin provisioning your infrastructure.

**Cleanup**
To destroy the infrastructure created by this configuration, run:
![image](https://github.com/user-attachments/assets/d8bf42ea-6b89-4bbe-8fbe-0b95527a3965)

This Terraform configuration sets up a basic VPC infrastructure with an EC2 instance and associated networking components. When deploying this configuration, make sure to:

**1.	Replace placeholders:** Customize the CIDR blocks, region, AMI ID, and key pair name based on your environment.

**2.	Harden security:** Restrict access where possible, use private subnets for internal resources, and apply the principle of least privilege to security groups and IAM roles.

