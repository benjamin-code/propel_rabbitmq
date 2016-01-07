default[:propel_nginx][:nginx_for_ui] = ""
default[:propel_nginx][:nginx_ha_master] = "atc-cr-iweb6"
default[:propel_nginx][:nginx_ha_backup] = "atc-cr-iweb7"
default[:propel_nginx][:propel_ui_1] = "30.161.224.142"
default[:propel_nginx][:propel_ui_2] = "30.161.224.143"
default[:propel_nginx][:propel_backend_1] = "atc-cr-wls3"
default[:propel_nginx][:propel_backend_2] = "atc-cr-wls4"
default[:propel_nginx][:postgres_1] = "30.161.224.146"
default[:propel_nginx][:postgres_2] = "30.161.224.147"
default[:propel_rabbitmq][:propel_backend_1_name] = "centos6-2"
default[:propel_rabbitmq][:propel_backend_2_name] = "centos6-2"

if ( node.ipaddress =~ /15.107(.*)/ )
  puts "This is the test environment"
default[:propel_nginx][:nginx_for_ui] = "15.107.13.37"
default[:propel_nginx][:nginx_ha_master] = "atc-cr-iweb6"
default[:propel_nginx][:nginx_ha_backup] = "atc-cr-iweb7"
default[:propel_nginx][:propel_ui_1] = "15.107.12.82"
default[:propel_nginx][:propel_ui_2] = "15.107.12.82"
default[:propel_nginx][:propel_backend_1] = "15.107.12.82"
default[:propel_nginx][:propel_backend_2] = "15.107.12.82"
default[:propel_nginx][:postgres_1] = "propel-ha-7"
default[:propel_nginx][:postgres_2] = "propel-ha-8"
default[:propel_rabbitmq][:propel_backend_1_name] = "centos6-5"
default[:propel_rabbitmq][:propel_backend_2_name] = "centos6-6"
end

if ( node.ipaddress =~ /30.161(.*)/ )
  puts "This is the N1 environment"
default[:propel_nginx][:nginx_for_ui] = "30.161.224.140"
default[:propel_nginx][:nginx_ha_master] = "30.161.224.141"
default[:propel_nginx][:nginx_ha_backup] = "30.161.224.148"
default[:propel_nginx][:propel_ui_1] = "30.161.224.142"
default[:propel_nginx][:propel_ui_2] = "30.161.224.143"
default[:propel_nginx][:propel_backend_1] = "30.161.224.144"
default[:propel_nginx][:propel_backend_2] = "30.161.224.145"
default[:propel_nginx][:postgres_1] = "30.161.224.146"
default[:propel_nginx][:postgres_2] = "30.161.224.147"
default[:propel_rabbitmq][:propel_backend_1_name] = "propel-ha-5"
default[:propel_rabbitmq][:propel_backend_2_name] = "propel-ha-6"
end
