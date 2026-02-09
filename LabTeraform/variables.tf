variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.large"
}

variable "key_name" {
  description = "Existing EC2 key pair name"
  type        = string
}

variable "ubuntu_ami" {
  description = "Ubuntu 24.04 LTS AMI (ap-south-1)"
  type        = string
  default     = "ami-019715e0d74f695be"
}
