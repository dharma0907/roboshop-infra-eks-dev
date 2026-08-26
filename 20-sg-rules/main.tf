# we arre defining ingress rules here

# MONGODB NEED TO ALLOW CATALOGUE, CATALOUGE AND BASTION HOST, PORT IS 27017
# MONGODB NEED TO ALLOW bastion, bastion AND BASTION HOST, PORT IS 22
resource "aws_security_group_rule" "mongodb_bastion" {
  type = "ingress"
  from_port   = 22
  protocol = "tcp"
  to_port     = 22
  source_security_group_id  = local.bastion_sg_id   #source is bastion, bastion wants to connect with mongodb
  security_group_id = local.mongodb_sg_id #mongodb id, because mongodb needs to allow bastion
  description = "Allow bastion to access mongodb"
}

#REDIS will allow traffic from user and cart


resource "aws_security_group_rule" "redis_bastion" {
  type = "ingress"
  from_port   = 22
  protocol = "tcp"
  to_port     = 22
  source_security_group_id  = local.bastion_sg_id   #source is bastion, bastion wants to connect with redis
  security_group_id = local.redis_sg_id    #redis id, because redis needs to allow bastion
  description = "Allow bastion to access redis"
}

# MySQL
resource "aws_security_group_rule" "mysql_bastion" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = local.bastion_sg_id
  security_group_id = local.mysql_sg_id
}

# RabbitMQ
resource "aws_security_group_rule" "rabbitmq_bastion" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = local.bastion_sg_id
  security_group_id = local.rabbitmq_sg_id
}

# Catalogue, this will access through backend alb

# Frontend ALB
resource "aws_security_group_rule" "public_alb_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = local.public_alb_sg_id
}

resource "aws_security_group_rule" "public_alb_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = local.public_alb_sg_id
}

# Bastion
resource "aws_security_group_rule" "bastion_my_public_ip" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks = ["${chomp(data.http.my_public_ip.response_body)}/32"]
  security_group_id = local.bastion_sg_id
}

#eks control plane should accept permission from bastion
resource "aws_security_group_rule" "eks_control_plane_bastion" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  source_security_group_id = local.bastion_sg_id
  security_group_id = local.eks_control_plane_sg_id
}

resource "aws_security_group_rule" "eks_nodegroup_eks_control_plane" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  source_security_group_id = local.eks_control_plane_sg_id
  security_group_id = local.eks_nodegroup_sg_id
}

resource "aws_security_group_rule" "eks_control_plane_eks_nodegroup" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  source_security_group_id = local.eks_nodegroup_sg_id
  security_group_id = local.eks_control_plane_sg_id # this is for control plane security group, so control plane can comm with node group
}

#eks node from CIDR, so all pods will be able to communicate with control plane
# Internal  communication b/w nodes nad secruity groups
resource "aws_security_group_rule" "eks_node_vpc" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks = ["10.0.0.0/16"]
  security_group_id = local.eks_nodegroup_sg_id # this isfor node group security group, all nodes can communicare each other
}

#jenkins should allow trafic from port 8080 and ssh on port 22
resource "aws_security_group_rule" "jenkins_public" {
  type = "ingress"
  from_port = 8080
  to_port = 8080
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = local.jenkins_sg_id

}

resource "aws_security_group_rule" "jenkins_ssh" {
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  #cidr_blocks = ["0.0.0.0/0"]
  cidr_blocks = ["${chomp(data.http.my_public_ip.response_body)}/32"]
  security_group_id = local.jenkins_sg_id

}

# JENKINS AGENT SHOULD ACCEPT TRAFFIC FROM JENKINS
resource "aws_security_group_rule" "jenkins_agent_jenkins" {
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  source_security_group_id = local.jenkins_sg_id # jenkins is source bcz jenkins to agne twe need connection
  security_group_id = local.jenkins_agent_sg_id # agent

}

resource "aws_security_group_rule" "jenkins_agent_ssh" {
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  #cidr_blocks = ["0.0.0.0/0"]
  cidr_blocks = ["${chomp(data.http.my_public_ip.response_body)}/32"]
  security_group_id = local.jenkins_agent_sg_id

}



# same way sonar SG rules we need to creare
resource "aws_security_group_rule" "sonar_web" {
  type = "ingress"
  from_port = 9000
  to_port = 9000
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = local.sonar_sg_id

}

resource "aws_security_group_rule" "sonar_ssh" {
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  cidr_blocks = ["${chomp(data.http.my_public_ip.response_body)}/32"] # this fetch my public ip i.e my internet connected ip
  #cidr_blocks = ["0.0.0.0/0"]
  security_group_id = local.sonar_sg_id

}

resource "aws_security_group_rule" "runner_ssh" {
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  cidr_blocks = ["${chomp(data.http.my_public_ip.response_body)}/32"] # this fetch my public ip i.e my internet connected ip
  #cidr_blocks = ["0.0.0.0/0"]
  security_group_id = local.runner_sg_id

}


#eks control plane should accept traffic from jenkins-agent
resource "aws_security_group_rule" "eks_control_plane_jenkins_agent" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  source_security_group_id = local.jenkins_agent_sg_id
  security_group_id = local.eks_control_plane_sg_id
}


#eks control plane should accept traffic from runner as well
resource "aws_security_group_rule" "eks_control_plane_runner" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  source_security_group_id = local.runner_sg_id
  security_group_id = local.eks_control_plane_sg_id
}