# ChefConf 2016
Materials from my talk at ChefConf 2016 "Cooking with AWS"

# Automatically clean up terminated AWS instances in your Chef Server
* https://github.com/awslabs/lambda-chef-node-cleanup
* https://aws.amazon.com/blogs/apn/automatically-delete-terminated-instances-in-chef-server-with-aws-lambda-and-cloudwatch-events/

# Sample Run Command Documents
*

# KMS Demo
aws kms encrypt --region us-west-2 --key-id KEYID --plaintext file://kms_demo.txt

aws kms encrypt --region us-west-2 --key-id KEYID --plaintext file://kms_demo.txt --query CiphertextBlob --output text | base64 --decode > kms_demo.txt.encrypted

aws kms decrypt --region us-west-2 --ciphertext-blob fileb://kms_demo.txt.encrypted --query Plaintext --output text | base64 --decode
