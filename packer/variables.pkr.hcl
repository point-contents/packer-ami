variable "ami-prefix" {
  type = string
  default  = "Alma 8 - CIS Level 1" 
}

variable "aws-region" {
  type = string
  default  = "us-east-1"
}

variable "build-instance-type" {
  type = string
  default  = "t3.small"
}

locals {
  scripts-folder  = "${path.root}/../scripts"
  manifest-folder = "${path.root}/../manifest"
  ansible-folder  = "${path.root}/../ansible"
}

