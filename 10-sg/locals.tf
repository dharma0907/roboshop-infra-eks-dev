# we are taking vpc id from data
locals {
    vpc_id = data.aws_ssm_parameter.vpc_id.value
}