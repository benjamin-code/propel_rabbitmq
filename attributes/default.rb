if node.chef_environment == 'prod'
default[:propel_rabbitmq][:propel_backend_1] = "atc-cr-wls3"
default[:propel_rabbitmq][:propel_backend_2] = "atc-cr-wls4"
default[:propel_nginx][:propel_cert_path] = "/opt/hp/propel/security/propel_prod.crt"
default[:propel_nginx][:propel_key_path] = "/opt/hp/propel/security/propel_prod.key"
end

if node.chef_environment == 'sandbox'
default[:propel_rabbitmq][:propel_backend_1] = "propel-ha-5"
default[:propel_rabbitmq][:propel_backend_2] = "propel-ha-6"
default[:propel_nginx][:propel_cert_path] = "/opt/hp/propel/security/propel_sandbox.crt"
default[:propel_nginx][:propel_key_path] = "/opt/hp/propel/security/propel_sandbox.key"
end

if node.chef_environment == 'env1'
default[:propel_rabbitmq][:propel_backend_1] = "pln-cd1-iweb3"
default[:propel_rabbitmq][:propel_backend_2] = "pln-cd1-iweb4"
default[:propel_nginx][:propel_cert_path] = "/opt/hp/propel/security/propel_env1.crt"
default[:propel_nginx][:propel_key_path] = "/opt/hp/propel/security/propel_env1.key"
end