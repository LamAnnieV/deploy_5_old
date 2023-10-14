################## D E C L A R E - V A R I A B L E ####################

################################### A W S #################################

variable "access_key" {}
variable "secret_key" {}
variable "region" {}

################################### V P C #################################

variable "aws_vpc_1_name" {}
variable "cidr_block" {}

################################### S U B N E T # 1 #################################

variable "availability_zone_1" {}
variable "aws_subnet_1_name" {}
variable "subnet_1_cidr_block" {}


################################### S U B N E T # 2 #################################

variable "availability_zone_2" {}
variable "aws_subnet_2_name" {}
variable "subnet_2_cidr_block" {}

###################### I N T E R N E T - G A T E W A Y #################################

variable "aws_igw_1_name" {}

###################### R O U T E - T A B L E #################################

variable "aws_rt_1_name" {} 

################################### I N S T A N C E # 1 #################################

variable "ami" {}
variable "instance_type_1" {}
#variable "instance_1_existing__subnet" {}      #f????or existing subnet
#variable "instance_1_existing_sg" {}      #????for existing sg
#variable "instance_1_new_sg" {}  #need to test
variable "instance_1_installs" {}
variable "key_pair" {}
variable "aws_instance_1_name" {}

################################### I N S T A N C E # 2 #################################
  
variable "instance_type_2" {}
#variable "instance_2_attach_existing_subnet" {}      #????or existing subnet
#variable "instance_2_existing_sg" {}      #????for existing sg
#variable "instance_2_new_sg" {} #need to test
variable "instance_2_installs" {}
variable "aws_instance_2_name" {}

####################### S E C U R I T Y - G R O U P # 1 ##############################

variable "aws_sg_1_name" {}
variable "sg_1_description" {}


####################### S E C U R I T Y - G R O U P # 2 ##############################

variable "aws_sg_2_name" {}
variable "sg_2_description" {}
