if ( node.hostname =~ /cr(.*)/ )
  puts "This is the Prod environment."
default[:propel_rabbitmq][:propel_backend_1] = "atc-cr-wls3"
default[:propel_rabbitmq][:propel_backend_2] = "atc-cr-wls4"
end

if node.chef_environment == 'sandbox'
  puts "This is the N1 environment"
default[:propel_rabbitmq][:propel_backend_1] = "propel-ha-5"
default[:propel_rabbitmq][:propel_backend_2] = "propel-ha-6"
end

if node.chef_environment == 'env1'
  puts "This is the FT1 environment"
default[:propel_rabbitmq][:propel_backend_1] = "pln-cd1-iweb3"
default[:propel_rabbitmq][:propel_backend_2] = "pln-cd1-iweb4"
end