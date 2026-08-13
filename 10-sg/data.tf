# this data block is for fetching value from aws ssm parameter
data "aws_ssm_parameter" "vpc_id" {
     name  = "/${var.project}/${var.environment}/vpc_id"
}