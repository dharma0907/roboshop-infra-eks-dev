resource "aws_route53_record" "jenkins" {
  count = var.jenkins ? 1 : 0
  zone_id = var.zone_id
  name    = "jenkins.${var.domain_name}"
  type    = "A"
  ttl     = "1"
  records = [aws_instance.jenkins[0].public_ip] # need to give public ip of instance, lets say we have created jenkins instance, for jenkins we are creating route, so need to public ip , so domain name will give trafic to public
  allow_overwrite = true
}


resource "aws_route53_record" "jenkins_agent" {
  count = var.jenkins ? 1 : 0
  zone_id = var.zone_id
  name    = "jenkins-agent.${var.domain_name}"
  type    = "A"
  ttl     = "1"
  records = [aws_instance.jenkins[0].public_ip] # need to give public ip of instance, lets say we have created jenkins instance, for jenkins we are creating route, so need to public ip , so domain name will give trafic to public
  allow_overwrite = true
}

resource "aws_route53_record" "sonarqube" {
  count = var.sonar ? 1 : 0
  zone_id = var.zone_id
  name    = "sonar.${var.domain_name}"
  type    = "A"
  ttl     = "1"
  records = [aws_instance.sonarqube[0].public_ip]
  allow_overwrite = true
}