provider "aws" {
  region = "us-west-2"
}

resource "aws_iam_instance_profile" "runcommand_chef_bootstrap_profile" {
    name = "runcommand_chef_bootstrap_profile"
    roles = ["${aws_iam_role.runcommand_chef_bootstrap_role.name}"]
}

resource "aws_iam_role" "runcommand_chef_bootstrap_role" {
    name = "runcommand_chef_bootstrap_role"
    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy_attachment" "runcommand_chef_bootstrap_policy_attach" {
    name = "runcommand_chef_bootstrap_policy_attach"
    roles = ["${aws_iam_role.runcommand_chef_bootstrap_role.name}"]
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}

resource "aws_iam_role_policy" "runcommand_chef_bootstrap_s3_policy" {
    name = "runcommand_chef_bootstrap_s3_policy"
    role = "${aws_iam_role.runcommand_chef_bootstrap_role.id}"
    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": ["s3:ListBucket"],
            "Resource": ["arn:aws:s3:::joshcbprivate"]
        },
        {
            "Sid": "Stmt1466437888000",
            "Effect": "Allow",
            "Action": [
                "s3:GetObject"
            ],
            "Resource": [
                "arn:aws:s3:::joshcbprivate/aws-validator.pem"
            ]
        },
        {
            "Sid": "Stmt1466438008000",
            "Effect": "Allow",
            "Action": [
                "s3:GetObject"
            ],
            "Resource": [
                "arn:aws:s3:::joshcbprivate/client.rb"
            ]
        }
    ]
}
EOF
}

resource "aws_instance" "demo_instances_linux" {
  ami = "ami-bf04f1df"
  instance_type = "t2.micro"
  iam_instance_profile = "${aws_iam_instance_profile.runcommand_chef_bootstrap_profile.name}"
  tags = {
    Name = "chef_demo_linux"
    organization = "aws"
  }
  count = 2
}

resource "aws_instance" "demo_instances_windows" {
  ami = "ami-8db945ed"
  instance_type = "t2.micro"
  iam_instance_profile = "${aws_iam_instance_profile.runcommand_chef_bootstrap_profile.name}"
  tags = {
    Name = "chef_demo_windows"
    organization = "aws"
  }
  count = 2
}
