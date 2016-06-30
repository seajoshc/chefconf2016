```python
import boto3
import base64

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
