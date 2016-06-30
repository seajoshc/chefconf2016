log_level :info
log_location STDOUT
chef_server_url 'https://your_chef_server_url/organizations/org_name'
validation_key '/etc/chef/client-validator.pem'
validation_client_name 'client-validator'
# Uncomment the below to disable SSL verification of the Chef Server
# ssl_verify_mode :verify_none
