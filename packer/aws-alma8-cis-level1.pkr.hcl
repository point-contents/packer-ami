packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

locals {
  timestamp		  = regex_replace(timestamp(), "[- TZ:]", "")
}

source "amazon-ebs" "alma" {
  ami_name      = "${var.ami-prefix} - ${local.timestamp}"
  instance_type = "${var.build-instance-type}"
  region        = "${var.aws-region}"
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
  #skip_create_ami = true
}

build {
  name = "Build CIS Alma"
  sources = [
    "source.amazon-ebs.alma"
  ]
  
  # example of running an arbitrary shell script
  # this copys from the script from the local machine 
  # to the remote and executes there
  provisioner "shell" {
	script = "${local.scripts-folder}/example-script.sh"
	execute_command = "{{.Vars}} bash '{{.Path}}'"
  }

  # Example of copying file from build AMI to local machine
  # Notice the "direction"
  provisioner "file" {
	source = "/tmp/ami-builder/file.html"
	destination = "/tmp/"
	direction = "download"
  }

  provisioner "ansible" {
	playbook_file = "${local.ansible-folder}/playbook.yml"
  }
  
  # This generates a json of build output information including the 
  # output AMI and other associated information
  post-processor "shell-local" {
	inline = ["mkdir ${local.manifest-folder}/${local.timestamp}"]
  }

  post-processor "manifest" {
	output = "${local.manifest-folder}/${local.timestamp}/${local.timestamp}-manifest.json"
  }
  
  # Post processors run after the build has completed
  # This example uploads the manifest to a remote s3 bucket which must exist
  # no buckets will be created by packer
  post-processor "shell-local" {
  	inline = ["aws s3 cp ${local.manifest-folder}/${local.timestamp}/ s3://test-ami-builder-test/manifest/${local.timestamp} --recursive"]
  } 
}

