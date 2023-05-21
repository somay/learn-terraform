
variable "server_port" {
  description = "the port the server will use for http requests"
  type        = number
  default     = 8080
}

variable "alb_name" {
  description = "the name of the alb"
  type        = string
  default     = "terraform-asg-example"
}

variable "instance_security_group_name" {
  description = "the name of the security group for the ec2 instances"
  type        = string
  default     = "terraform-example-instance"
}

variable "alb_security_group_name" {
  description = "the name of the security group for the alb"
  type        = string
  default     = "terraform-example-alb"
}
