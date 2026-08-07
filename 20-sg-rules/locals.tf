locals {
    #catalogue_sg_id = data.aws_ssm_parameter.catalogue_sg_id.value
    mongodb_sg_id = data.aws_ssm_parameter.mongodb_sg_id.value
    redis_sg_id = data.aws_ssm_parameter.redis_sg_id.value
    mysql_sg_id = data.aws_ssm_parameter.mysql_sg_id.value
    rabbitmq_sg_id = data.aws_ssm_parameter.rabbitmq_sg_id.value
  
    public_alb_sg_id = data.aws_ssm_parameter.public_alb_sg_id.value
    bastion_sg_id = data.aws_ssm_parameter.bastion_sg_id.value
    eks_control_plane_sg_id = data.aws_ssm_parameter.eks_control_plane_sg_id.value
    eks_nodegroup_sg_id = data.aws_ssm_parameter.eks_nodegroup_sg_id.value
}


