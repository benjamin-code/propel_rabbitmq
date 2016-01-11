#
# Cookbook Name:: propel_rabbitmq
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

yum_package 'erlang' do
  action :install
  flush_cache [ :before ]
end

if ( node.hostname =~ /centos6(.*)/ )
  execute "Download rabbitmq-server-3.5.4-1.noarch.rpm" do
  user "root"
  cwd   "/tmp"
  command "wget https://www.rabbitmq.com/releases/rabbitmq-server/v3.5.4/rabbitmq-server-3.5.4-1.noarch.rpm & rpm -Uvh /tmp/rabbitmq-server-3.5.4-1.noarch.rpm"
  end
end

if ( node.hostname =~ /propel-ha(.*)/ )
    remote_file "/tmp/rabbitmq-server-3.5.4-1.noarch.rpm" do
      source 'http://30.161.224.150/rpm/rabbitmq-server-3.5.4-1.noarch.rpm' 
      mode "0755"
      notifies   :run, 'execute[Install-rabbitmq-server]', :immediately
      notifies :run, "bash[Add-user]"
      action  :create_if_missing
    end
    execute "Install-rabbitmq-server" do
      user "root"
      command "rpm -Uvh /tmp/rabbitmq-server-3.5.4-1.noarch.rpm"
      action :nothing
    end
end

if ( node.hostname =~ /atc(.*)/ )
  yum_package 'rabbitmq-server' do
    action :install
    flush_cache [ :before ]
    notifies :run, "bash[Add-user]"
  end
end
service 'rabbitmq-server' do
    service_name 'rabbitmq-server'
  action [:enable, :start]
end

bash "Add-user" do
    action  :nothing
    code <<-EOH
      rabbitmqctl add_user rabbit_sx propel2014
      rabbitmqctl set_user_tags rabbit_sx administrator
      rabbitmqctl set_permissions -p / rabbit_sx ".*" ".*" ".*"
    EOH
end

cookbook_file '/var/lib/rabbitmq/.erlang.cookie' do
  source '.erlang.cookie'
  owner 'rabbitmq'
  group 'rabbitmq'
  mode '0400'
  notifies :restart, "service[rabbitmq-server]"
end


#Import ssl for Nginx to truststore. 
#include_recipe "propel_nginx::import_ssl"

#Import ssl cert for rabbitmq
#cookbook_file '/tmp/ssl_crt_rabbitmq.tar.gz' do
#  source 'ssl_crt_rabbitmq.tar.gz'
#  mode '0755'
#end

#if ( node.ipaddress =~ /30.161(.*)/ )
#if ( node.ipaddress =~ /15.107(.*)/ )

#  puts "This is the N1 environment"
#  bash "import-ssl" do 
#   cwd   '/tmp'
#  code <<-EOH
#      tar zxf /tmp/ssl_crt_rabbitmq.tar.gz 
#      if ! keytool -list -keystore /opt/hp/propel/security/propel.truststore -storepass "propel2014" | grep -q propel-ha-5
#        then
#      keytool -importcert -file /tmp/ssl_crt/propel-ha-5.hp.com_propel_host.crt -keystore /opt/hp/propel/security/propel.truststore -alias "propel-ha-5.hp.com" -storepass "propel2014" -noprompt
#      fi
#      if ! keytool -list -keystore /opt/hp/propel/security/propel.truststore -storepass "propel2014" | grep -q propel-ha-6
#        then
#      keytool -importcert -file /tmp/ssl_crt/propel-ha-6.hp.com_propel_host.crt -keystore /opt/hp/propel/security/propel.truststore -alias "propel-ha-6.hp.com" -storepass "propel2014" -noprompt
#      fi
#      EOH
#  end
#else
#  puts "This is the Prod environment"
#  bash "import-ssl" do 
#   cwd   '/tmp'
#   code <<-EOH
#      tar zxf /tmp/ssl_crt_rabbitmq.tar.gz 
#    if ! keytool -list -keystore /opt/hp/propel/security/propel.truststore -storepass "propel2014" | grep -q atc-cr-wls3
#        then
#      keytool -importcert -file /tmp/ssl_crt/atc-cr-wls3_propel_host.crt -keystore /opt/hp/propel/security/propel.truststore -alias "atc-cr-wls3" -storepass "propel2014" -noprompt
#      fi
#      if ! keytool -list -keystore /opt/hp/propel/security/propel.truststore -storepass "propel2014" | grep -q atc-cr-wls4
#        then
#      keytool -importcert -file /tmp/ssl_crt/atc-cr-wls4_propel_host.crt -keystore /opt/hp/propel/security/propel.truststore -alias "atc-cr-wls4" -storepass "propel2014" -noprompt
#      fi
#      EOH
#  end
#end

#Configure nginx configuration file for reserve proxy
#if server_ipaddress == node[:propel_rabbitmq][:propel_backend_2]
#  template "/tmp/add_cluster.sh" do
#    source "add_cluster.sh"
#    mode '0755'
#    variables ({
#      :clustermaster => node[:propel_rabbitmq][:propel_backend_1_name],
#    })
#  end
#enable rabbitmq management plugin in node1
#  execute "add_cluster" do
#    user "root"
#    command "/tmp/add_cluster.sh"
#  end
#end

#enable rabbitmq management plugin in node1
#execute "enable rabbitmq management plugin in node1" do
#  user "root"
#  command "rabbitmq-plugins enable rabbitmq_management"
#  end
