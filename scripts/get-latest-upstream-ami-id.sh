#! /usr/bin/env bash

aws ec2 describe-images \
    --owners aws-marketplace \
    --filters '[
        {"Name": "name",                "Values": ["CIS Alma Linux 8*"]},
        {"Name": "virtualization-type", "Values": ["hvm"]},
        {"Name": "architecture",        "Values": ["x86_64"]},
        {"Name": "image-type",          "Values": ["machine"]},
		{"Name": "hypervisor",			"Values": ["xen"]}
    ]' \
    --query 'sort_by(Images, &CreationDate)[-1]' \
    --region us-east-1 \
    --output json

