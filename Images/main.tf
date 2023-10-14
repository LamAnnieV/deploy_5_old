
################################### A W S #################################
# configure aws provider (provider block: 
provider "aws" {
  access_key = var.access_key  #enter your aws access_key
  secret_key = var.secret_key  #enter your aws secret_key
  region = var.region   #Availability Zone
  #profile = "Admin"
}
################################### V P C #################################
# Create VPC
resource "aws_vpc" "tf_local_vpc_1" {
cidr_block              = var.cidr_block
instance_tenancy        = "default"
enable_dns_hostnames    = true

  tags      = {
    Name    = var.aws_vpc_1_name
  }
}

################################### S U B N E T # 1 #################################
# Create a subnet_1 within the VPC
resource "aws_subnet" "tf_local_subnet_1" {
  vpc_id = aws_vpc.tf_local_vpc_1.id
  cidr_block = var.subnet_1_cidr_block
  availability_zone = var.availability_zone_1
  map_public_ip_on_launch = true

  tags      = {
    Name    = var.aws_subnet_1_name
  }
}


################################### S U B N E T # 2 #################################
# Create a subnet_1 within the VPC
resource "aws_subnet" "tf_local_subnet_2" {
  vpc_id                  = aws_vpc.tf_local_vpc_1.id
  cidr_block              = var.subnet_2_cidr_block
  availability_zone       = var.availability_zone_2
  map_public_ip_on_launch = true

  tags      = {
    Name    = var.aws_subnet_2_name
  }
}



###################### I N T E R N E T - G A T E W A Y #################################
resource "aws_internet_gateway" "tf_local_igw" {
  vpc_id = aws_vpc.tf_local_vpc_1.id
  tags = {
    Name = var.aws_igw_1_name
  }
}

######### A T T A C H - I N T E R N E T - G A T E W A Y #######################
resource "aws_internet_gateway_attachment" "tf_local_igw_attachment" {
  vpc_id             = aws_vpc.tf_local_vpc_1.id
  internet_gateway_id = aws_internet_gateway.tf_local_igw.id
}

###################### R O U T E - T A B L E #################################
#resource "aws_route_table" "tf_local_rt_1" {
  #vpc_id = aws_vpc.tf_local_vpc_1.id
  #tags = {
    #Name = var.aws_rt_1_name
  #}
#}

###################### D E F A U L T - R O U T E - T A B L E #################################
resource "aws_default_route_table" "example" {
  default_route_table_id = aws_vpc.tf_local_vpc_1.default_route_table_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tf_local_igw.id
  }
}

###################### A T T A C H - R O U T E - T A B L E  #################################
resource "aws_route" "tf_local_attach_rt_igw" {
  route_table_id         = aws_route_table.tf_local_rt_1.id
  destination_cidr_block = "0.0.0.0/0"  # This is the default route for the internet
  gateway_id             = aws_internet_gateway.tf_local_igw.id
}

################################### I N S T A N C E # 1 #################################

# create instance  #Resource Block to create an AWS instance

resource "aws_instance" "tf_local_instance_1" {
  ami = var.ami                            #AMI ID for Ubuntu
  instance_type = var.instance_type_1
  subnet_id = aws_subnet.tf_local_subnet_1.id 
  
  #security_groups = var.instance_1_existing_sg  #existing sg
  vpc_security_group_ids = [aws_security_group.tf_local_security_group_1.id]  #new sg

  user_data = "${file(var.instance_1_installs)}"
  key_name = var.key_pair          # name of your SSH key pair
  associate_public_ip_address = true  # Enable Auto-assign public IP

  tags = {
    "Name" : var.aws_instance_1_name     #name of the instance in AWS
  }
}


################################### I N S T A N C E # 2 #################################

# create instance  #Resource Block to create an AWS instance

resource "aws_instance" "tf_local_instance_2" {
  ami = var.ami                            #AMI ID for Ubuntu
  instance_type = var.instance_type_2
  subnet_id = aws_subnet.tf_local_subnet_2.id
  
   #security_groups = var.instance_1_existing_sg.id   #existing sg     
  vpc_security_group_ids = [aws_security_group.tf_local_security_group_2.id]   #new sg 
  user_data = "${file(var.instance_2_installs)}"
  key_name = var.key_pair          # name of your SSH key pair
  associate_public_ip_address = true  # Enable Auto-assign public IP

  tags = {
    "Name" : var.aws_instance_2_name   #name of the instance in AWS
  }
}

####################### S E C U R I T Y - G R O U P # 1 ##############################
# Create security groups      #Resource Block to create Security Group

resource "aws_security_group" "tf_local_security_group_1" {      
  name        = var.aws_sg_1_name                   
  description = var.sg_1_description
  vpc_id = aws_vpc.tf_local_vpc_1.id

#Ingress is for Inbound rules/ports
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

#Egress is for Outbound rules/ports
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" : var.aws_sg_1_name
    "Terraform" : "true"
  }
}

####################### S E C U R I T Y - G R O U P # 2 ##############################
# Create security groups      #Resource Block to create Security Group

resource "aws_security_group" "tf_local_security_group_2" {      
  name        = var.aws_sg_2_name                   
  description = var.sg_2_description
  vpc_id = aws_vpc.tf_local_vpc_1.id

#Ingress is for Inbound rules/ports
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 8000
    to_port = 8000
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


#Egress is for Outbound rules/ports
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" : var.aws_sg_1_name
    "Terraform" : "true"
  }
}


################################### O U T P U T #################################
#Output Block
output "instance_1_ip" {            
  value = aws_instance.tf_local_instance_1.public_ip
}
output "instance_2_ip" {            
  value = aws_instance.tf_local_instance_2.public_ip
}
