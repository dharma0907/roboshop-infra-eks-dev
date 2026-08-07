locals {
    eks_cluster_name = data.aws_ssm_parameter.eks_cluster_name.value
    bastion_iam_role_arm = data.aws_ssm_parameter.bastion_iam_role_arn.value
}