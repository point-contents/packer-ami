packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

variable "ami_prefix" {
  type = string
  default = "Alma 8 - CIS Level 1"
}

locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

source "amazon-ebs" "ubuntu" {
  ami_name      = "${var.ami_prefix} - ${local.timestamp}"
  instance_type = "t3.small"
  region        = "us-east-1"
  source_ami_filter {
    filters = {
      name                = "CIS Alma Linux 8*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
	  hypervisor		  = "xen"
	  architecture		  = "x86_64"

    }
    most_recent = true
    owners      = ["679593333241"]
  }
  ssh_username = "ec2-user"
}

build {
  name = "learn-packer"
  sources = [
    "source.amazon-ebs.ubuntu"
  ]
  
  provisioner "shell" {
	script = "script.sh"
	execute_command = "{{.Vars}} bash '{{.Path}}'"
  }

  provisioner "file" {
	source = "/tmp/ami-builder/file.html"
	destination = "manifest/${local.timestamp}/"
	direction = "download"
  }

  post-processor "manifest" {
	output = "manifest/${local.timestamp}/${local.timestamp}-manifest.json"
  }
  
  post-processor "shell-local" {
	inline = ["aws s3 cp manifest/${local.timestamp}/ s3://test-ami-builder-test/manifest/${local.timestamp}/ --recursive"]
  } 
}

