#mongodb
data "aws_ssm_parameter" "mongodb_sg_id" {
    name = "/${var.project}/${var.environment}/mongodb_sg_id"
}

#redis
data "aws_ssm_parameter" "redis_sg_id" {
    name = "/${var.project}/${var.environment}/redis_sg_id"
}

#mysql
data "aws_ssm_parameter" "mysql_sg_id" {
    name = "/${var.project}/${var.environment}/mysql_sg_id"
}

#rabbitmq
data "aws_ssm_parameter" "rabbitmq_sg_id" {
    name = "/${var.project}/${var.environment}/rabbitmq_sg_id"
}


#frontend LB
data "aws_ssm_parameter" "public_alb_sg_id" {
    name = "/${var.project}/${var.environment}/public_alb_sg_id"
}

#bastion
data "aws_ssm_parameter" "bastion_sg_id" {
    name = "/${var.project}/${var.environment}/bastion_sg_id"
}
# these two are added in secruity group rules for eks cluster, we are getting id here
data "aws_ssm_parameter" "eks_control_plane_sg_id" {
    name = "/${var.project}/${var.environment}/eks_control_plane_sg_id"
}

data "aws_ssm_parameter" "eks_nodegroup_sg_id" {
    name = "/${var.project}/${var.environment}/eks_nodegroup_sg_id"
}

#this is for my ip
data "http" "my_public_ip" {
  url = "https://ipv4.icanhazip.com"
}