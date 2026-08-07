data "aws_ssm_parameter" "eks_cluster_name" {
    name = "/${var.project}/${var.environment}/eks_cluster_name"
}

# bastion arn fetching from parameter store
data "aws_ssm_parameter" "bastion_iam_role_arn" {

    name = "/${var.project}/${var.environment}/bastion_iam_role_arn"
}