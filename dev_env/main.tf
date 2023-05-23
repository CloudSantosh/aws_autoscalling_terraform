#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# create VPC
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
module "vpc" {

  source                 = "../modules/vpc"
  region                 = var.region
  project_name           = var.project_name
  vpc_cidr               = var.vpc_cidr
  public_subnet_az1_cidr = var.public_subnet_az1_cidr
  public_subnet_az2_cidr = var.public_subnet_az2_cidr

}


#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# create Security Group
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
module "security_groups" {

  source = "../modules/security_groups"
  vpc_id = module.vpc.vpc_id

}


#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# create key pair
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

module "keypair_generator" {

  source = "../modules/keypair_generator"
}


#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#  create auto-scalling
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
module "auto_scaling" {

  source                    = "../modules/auto_scalling"
  project_name              = module.vpc.project_name
  public_subnet_az1_id      = module.vpc.public_subnet_az1_id
  public_subnet_az2_id      = module.vpc.public_subnet_az2_id
  public_ec2_security_group = module.security_groups.public_ec2_security_group_id
  key_name                  = module.keypair_generator.key_id
  min_size                  = var.min_size
  max_size                  = var.max_size
  instance_type             = var.instance_type
}

