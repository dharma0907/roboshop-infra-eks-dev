resource "aws_ssm_parameter" "public_alb_listener_arn" {
  name  = "/${var.project}/${var.environment}/public_alb_listener_arn"
  type  = "String"
  value = aws_lb_listener.http.arn
  overwrite = true
}