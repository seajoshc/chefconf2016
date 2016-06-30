# Node Cleanup

## KMS
aws kms encrypt --region us-west-2 --key-id 783ab07d-1458-4b43-b31b-12710aceac60 --plaintext file://kms_demo.txt

aws kms encrypt --region us-west-2 --key-id 783ab07d-1458-4b43-b31b-12710aceac60 --plaintext file://kms_demo.txt --query CiphertextBlob --output text | base64 --decode > kms_demo.txt.encrypted

aws kms decrypt --region us-west-2 --ciphertext-blob fileb://kms_demo.txt.encrypted --query Plaintext --output text | base64 --decode

# Run Command
