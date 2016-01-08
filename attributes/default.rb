#Prod
default[:propel_rabbitmq][:propel_backend_1] = "atc-cr-wls3"
default[:propel_rabbitmq][:propel_backend_2] = "atc-cr-wls4"

#Test
if ( node.hostname =~ /centos6(.*)/ )
  puts "This is the test environment"
default[:propel_rabbitmq][:propel_backend_1] = "centos6-5"
default[:propel_rabbitmq][:propel_backend_2] = "centos6-6"
end

#N1
if ( node.hostname =~ /propel-ha(.*)/ )
  puts "This is the N1 environment"
default[:propel_rabbitmq][:propel_backend_1] = "propel-ha-5"
default[:propel_rabbitmq][:propel_backend_2] = "propel-ha-6"
end
