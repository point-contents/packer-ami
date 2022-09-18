# Packer to Build a Golden AMI

Takes the most recent AlmaLinux 8 from the CIS profile on AWS marketplace.

Updates all packages, and can do further customisations.

Packer script has a few examples of customisations (Ansible, Arbitrary Bash) that can happen on the build EC2.
This EC2 is then exported as an AMI that can be used to provision further EC2's.

There is further configuration that can be made in the packer script, such as distrubuting images over different
regions.

After running, a manifest is uploaded to a timestamped folder in a s3 bucket. An example of these manifests is in the manifest folder


> TODO 
> - Create either terraform or cdk to create s3 bucket, iam user, role, and permissions.
> - Add tagging to AMI's
> - Add packer runtime logs to the manifest folder

## Usage

Authenticate as the AWS Iam User using env variables

```
export AWS_ACCESS_KEY_ID="a secret key ID"
export AWS_SECRET_ACCESS_KEY="a secret key"
```

Build the AMI

```
packer build packer
```


# Requirements

*Packer* - [Installation Instructions](https://learn.hashicorp.com/tutorials/packer/get-started-install-cli)

```
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
sudo yum -y install packer
```

An AWS user.

The following IAM policies to write to the s3 bucket and building EC2's 
These need to be either attached to the user, or a role that the user can assume.

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket"
            ],
            "Resource": "arn:aws:s3:::BUCKET"
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:ListBucket"
            ],
            "Resource": [
                "arn:aws:s3:::BUCKET/*"
            ]
        }
    ]
}
```

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ec2:AttachVolume",
                "ec2:AuthorizeSecurityGroupIngress",
                "ec2:CopyImage",
                "ec2:CreateImage",
                "ec2:CreateKeypair",
                "ec2:CreateSecurityGroup",
                "ec2:CreateSnapshot",
                "ec2:CreateTags",
                "ec2:CreateVolume",
                "ec2:DeleteKeyPair",
                "ec2:DeleteSecurityGroup",
                "ec2:DeleteSnapshot",
                "ec2:DeleteVolume",
                "ec2:DeregisterImage",
                "ec2:DescribeImageAttribute",
                "ec2:DescribeImages",
                "ec2:DescribeInstances",
                "ec2:DescribeInstanceStatus",
                "ec2:DescribeRegions",
                "ec2:DescribeSecurityGroups",
                "ec2:DescribeSnapshots",
                "ec2:DescribeSubnets",
                "ec2:DescribeTags",
                "ec2:DescribeVolumes",
                "ec2:DetachVolume",
                "ec2:GetPasswordData",
                "ec2:ModifyImageAttribute",
                "ec2:ModifyInstanceAttribute",
                "ec2:ModifySnapshotAttribute",
                "ec2:RegisterImage",
                "ec2:RunInstances",
                "ec2:StopInstances",
                "ec2:TerminateInstances"
            ],
            "Resource": "*"
        }
    ]
}
```





