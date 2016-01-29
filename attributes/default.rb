if node.chef_environment == 'prod'
default[:propel_rabbitmq][:propel_backend_1] = "atc-cr-wls3"
default[:propel_rabbitmq][:propel_backend_2] = "atc-cr-wls4"
default[:propel_rabbitmq][:propel_backend_3] = "swa-cr-wls3"
default[:propel_rabbitmq][:propel_backend_4] = "swa-cr-wls4"
end

if node.chef_environment == 'sandbox'
default[:propel_rabbitmq][:propel_backend_1] = "propel-ha-5"
default[:propel_rabbitmq][:propel_backend_2] = "propel-ha-6"
end

if node.chef_environment == 'env1'
default[:propel_rabbitmq][:propel_backend_1] = "pln-cd1-iweb3"
default[:propel_rabbitmq][:propel_backend_2] = "pln-cd1-iweb4"
end