
# these two are added in secruity group rules for eks cluster, we are getting id here
data "aws_ssm_parameter" "eks_control_plane_sg_id" {
    name = "/${var.project}/${var.environment}/eks_control_plane_sg_id"
}

data "aws_ssm_parameter" "eks_nodegroup_sg_id" {
    name = "/${var.project}/${var.environment}/eks_nodegroup_sg_id"
}


data "aws_ssm_parameter" "vpc_id" {
    name = "/${var.project}/${var.environment}/vpc_id"
}

data "aws_ssm_parameter" "private_subnet_ids" {
    name = "/${var.project}/${var.environment}/private_subnet_ids"
}

data "aws_ssm_parameter" "public_subnet_ids" {
    name = "/${var.project}/${var.environment}/public_subnet_ids"
}
