# KMS Demo
## AWS CLI
aws kms encrypt --region us-west-2 --key-id KEYID --plaintext file://kms_demo.txt

aws kms encrypt --region us-west-2 --key-id KEYID --plaintext file://kms_demo.txt --query CiphertextBlob --output text | base64 --decode > kms_demo.txt.encrypted

aws kms decrypt --region us-west-2 --ciphertext-blob fileb://kms_demo.txt.encrypted --query Plaintext --output text | base64 --decode

## Python
```python
import boto3

client = boto3.client('kms', region_name='us-west-2')
encrypt_response = client.encrypt(
    KeyId='783ab07d-1458-4b43-b31b-12710aceac60',
    Plaintext='Chef Conf 2016'
)

ciphertext = encrypt_response['CiphertextBlob']

decrypt_response = client.decrypt(
    CiphertextBlob=ciphertext
)

decrypt_response['Plaintext']
```
