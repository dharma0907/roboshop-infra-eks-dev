resource "aws_eks_access_entry" "bastion" {
  cluster_name      = local.eks_cluster_name # this is eks cluster name
  principal_arn     = local.bastion_iam_role_arm # this is for iam role for eks cluster access
  type              = "STANDARD"
}
# we are giving clusteradmin access to bastion here
resource "aws_eks_access_policy_association" "bastion" {
  cluster_name  = local.eks_cluster_name
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  principal_arn = local.bastion_iam_role_arm

  access_scope {
    type       = "cluster"
  }
}