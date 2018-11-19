#!/bin/sh

export VAULT_ADDR='http://0.0.0.0:8200'

vault login {{root_token}}
vault secrets enable database
vault write database/config/testdatabase plugin_name=mysql-database-plugin root_rotation_statements="SET PASSWORD FOR 'root'@'%' = PASSWORD('{{password}}')" root_rotation_statements="SET PASSWORD FOR 'root'@'localhost' = PASSWORD('{{password}}')" connection_url="{{username}}:{{password}}@tcp(composefiles_database-node-1_1:3306)/" allowed_roles="update-role, read-role"  username="root" password="onetimepasswordeoirgj3434oijwgøorigjqw34toi34nhwoh4oin"
vault write database/roles/update-role db_name=testdatabase creation_statements="CREATE USER '{{name}}'@'%' IDENTIFIED BY '{{password}}';GRANT SELECT, UPDATE, INSERT ON *.* TO '{{name}}'@'%';" default_ttl="1h" max_ttl="24h"
vault write database/roles/read-role db_name=testdatabase creation_statements="CREATE USER '{{name}}'@'%' IDENTIFIED BY '{{password}}';GRANT SELECT ON *.* TO '{{name}}'@'%';" default_ttl="1h" max_ttl="24h"
vault write -force database/rotate-root/testdatabase
vault read database/creds/update-role
vault read database/creds/read-role