#
# Cookbook Name:: propel_rabbitmq
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
#Install Nginx via yum
server_name = node.ipaddress
propel_backend_1 = node[:propel_rabbitmq][:propel_backend_1]
propel_backend_2 = node[:propel_rabbitmq][:propel_backend_2]
propel_backend_1_name = node[:propel_rabbitmq][:propel_backend_1_name]
username        = node[:propel_rabbitmq][:user]
userid          = node[:propel_rabbitmq][:user_id]
userhome        = node[:propel_rabbitmq][:user_home]
usershell       = node[:propel_rabbitmq][:user_shell]
userpassword    = node[:propel_rabbitmq][:user_password]
groupname       = node[:propel_rabbitmq][:group]
groupid         = node[:propel_rabbitmq][:group_id]

cookbook_file '/tmp/yumrepo.tar.gz' do
  source 'yumrepo.tar.gz'
  mode '0755'
end

bash "import-rpm" do 
  cwd   '/'
#  action :nothing
  code <<-EOH
      tar zxf /tmp/yumrepo.tar.gz etc
      tar zxf /tmp/yumrepo.tar.gz tmp
      rpm --import /tmp/erlang_solutions.asc
      rpm --import /tmp/RPM-GPG-KEY.dag.txt
      EOH
end

yum_package 'erlang' do
  action :install
  flush_cache [ :before ]
end

cookbook_file '/tmp/rabbitmq-server-3.6.0-1.noarch.rpm' do
  source 'rabbitmq-server-3.6.0-1.noarch.rpm'
  mode '0755'
end

rpm_package 'rabbitmq-server-3.6.0-1.noarch.rpm' do
  source '/tmp/rabbitmq-server-3.6.0-1.noarch.rpm'
  action :install
end

#Stop rabbitmq in two servers with command
execute "Start rabbitmq server" do
   user "root"
   command "/etc/init.d/rabbitmq-server start"
end

#Add new user for propel, and grant admin privilege, and set full permission for vhost "/". Do it in both nodes
execute "Add-user" do
   user "root"
   command <<-EOH
      rabbitmqctl add_user rabbit_sx propel2014
      rabbitmqctl set_user_tags rabbit_sx administrator
      rabbitmqctl set_permissions -p / rabbit_sx ".*" ".*" ".*"
      EOH
end

#Stop rabbitmq in two servers with command
execute "Stop-rabbitmq" do
   user "root"
   command "rabbitmqctl stop"
end

cookbook_file '/var/lib/rabbitmq/.erlang.cookie' do
  source '.erlang.cookie'
  owner 'rabbitmq'
  group 'rabbitmq'
  mode '0400'
end


cookbook_file '/etc/rabbitmq/rabbitmq.config' do
  source 'rabbitmq.config'
  mode '0755'
end

#Import ssl for Nginx to truststore
include_recipe "propel_nginx::import_ssl"

#Import ssl cert fir rabbitmq
cookbook_file '/tmp/ssl_crt_56.tar.gz' do
  source 'ssl_crt_56.tar.gz'
  mode '0755'
end

bash "import-ssl" do 
  cwd   '/tmp'
#  action :nothing
  code <<-EOH
      tar zxf /tmp/ssl_crt_56.tar.gz 
      keytool -importcert -file propel-ha-5.hp.com_propel_host.crt -keystore propel.truststore -alias "propel-ha-5.hp.com" -storepass "propel2014" -noprompt
      keytool -importcert -file propel-ha-6.hp.com_propel_host.crt -keystore propel.truststore -alias "propel-ha-6.hp.com" -storepass "propel2014" -noprompt
      EOH
end

#Start rabbitmq server
execute "Start rabbitmq server" do
  user "root"
  command "/etc/rc.d/init.d/rabbitmq-server start"
  end

#Configure nginx configuration file for reserve proxy
if server_name == propel_backend_2
  template "/tmp/add_cluster.sh" do
    source "add_cluster.sh"
    mode '0755'
    variables ({
      :clustermaster => propel_backend_1_name,
    })
  end
#enable rabbitmq management plugin in node1
  execute "add_cluster" do
    user "root"
    command "/tmp/add_cluster.sh"
  end
end

#enable rabbitmq management plugin in node1
execute "enable rabbitmq management plugin in node1" do
  user "root"
  command "rabbitmq-plugins enable rabbitmq_management"
  end
