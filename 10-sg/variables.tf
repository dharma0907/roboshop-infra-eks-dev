variable "project" {
  default = "roboshop"
}

variable "environment" {
  default = "dev"
}


variable "sg_names" {
    type = list
    default = [
        "mongodb", "redis", "mysql", "rabbitmq",
        #"catalogue", "user", "cart", "shipping", "payment",
        #"backend_alb",
        #"frontend",
        "public_alb",
        "bastion",
        "eks_control_plane", #this we are required for secruity group of control plane
        "eks_nodegroup", #SG for node group, we are adding it here
        "jenkins","jenkins-agent","sonar" # secruity groups for jenkins and sonar, withe these names only aws store value of SG in aws parameter
    ]
}