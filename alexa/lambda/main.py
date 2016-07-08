"""
Runs Chef Compliance Run Command Document on Matching Instances.
Demo for ChefConf 2016
joshcb@amazon.com
v1.0.0
"""
from __future__ import print_function
import logging
from botocore.exceptions import ClientError
import boto3

LOGGER = logging.getLogger()
LOGGER.setLevel(logging.INFO)

def find_instances():
    """
    Find Instances to invoke Run Command against
    """
    instance_ids = []
    filters = [
        {'Name': 'tag:Name', 'Values': ['chef_demo_linux']},
        {'Name': 'instance-state-name', 'Values': ['running']}
    ]
    try:
        instance_ids = find_instance_ids(filters)
        print(instance_ids)
    except ClientError as err:
        LOGGER.error("Failed to DescribeInstances with EC2!\n%s", err)

    return instance_ids

def find_instance_ids(filters):
    """
    EC2 API calls to retrieve instances matched by the filter
    """
    ec2 = boto3.resource('ec2', region_name='us-west-2')
    return [i.id for i in ec2.instances.all().filter(Filters=filters)]

def send_run_command(instance_ids):
    """
    Tries to queue a RunCommand job.  If a ThrottlingException is encountered
    recursively calls itself until success.
    """
    try:
        ssm = boto3.client('ssm', region_name='us-west-2')
    except ClientError as err:
        LOGGER.error("Run Command Failed!\n%s", str(err))
        return False

    try:
        ssm.send_command(
            InstanceIds=instance_ids,
            DocumentName='ChefConf_Linux_ChefCompliance',
        )
        LOGGER.info('============RunCommand sent successfully')
        return True
    except ClientError as err:
        if 'ThrottlingException' in str(err):
            LOGGER.info("RunCommand throttled, automatically retrying...")
            send_run_command(instance_ids)
        else:
            LOGGER.error("Run Command Failed!\n%s", str(err))
            return False

def build_speechlet_response():
    '''
    Return speech out and card
    '''
    return {
        'outputSpeech': {
            'type': 'PlainText',
            'text': 'Compliance Check Started.'
        },
        'card': {
            'type': 'Simple',
            'title': 'Run Command Sent',
            'content': 'Compliance Check Started'
        },
        'shouldEndSession': True
    }

def build_response(session_attributes, speechlet_response):
    return {
        'version': '1.0',
        'sessionAttributes': session_attributes,
        'response': speechlet_response
    }

def handle(event, _context):
    """
    Lambda main handler
    """
    LOGGER.info('Lambda started...')
    LOGGER.info(event)

    send_run_command(find_instances())
    return build_response({}, build_speechlet_response())
