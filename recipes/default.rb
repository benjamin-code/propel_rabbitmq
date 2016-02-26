#
# Cookbook Name:: propel_rabbitmq
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

cookbook_file '/etc/yum.repos.d/erlang_solutions.repo' do
  source 'erlang_solutions.repo'
  mode '0644'
  only_if { node.hostname =~ /propel-ha(.*)/  }
end

yum_package 'erlang' do
  flush_cache [ :before ]
end

if ( node.hostname =~ /propel-ha(.*)/ )
    remote_file "/tmp/rabbitmq-server-3.5.4-1.noarch.rpm" do
      source 'http://30.161.224.150/rpm/rabbitmq-server-3.5.4-1.noarch.rpm' 
      mode "0755"
      action  :create_if_missing
    end
   
  bash "Install-rabbitmq-server" do
    code <<-EOH
         if [ ! -f "/etc/init.d/rabbitmq-server" ]; then
            rpm -Uvh /tmp/rabbitmq-server-3.5.4-1.noarch.rpm
         fi
        EOH
    end
end

if node.chef_environment == 'env1' || node.chef_environment == 'prod'
  yum_package 'rabbitmq-server' do
    action :install
    flush_cache [ :before ]
  end
end

service 'rabbitmq-server' do
    service_name 'rabbitmq-server'
    action [ :stop]
    not_if "grep -q ERHDIBXLEUHAKDFMMHDN /var/lib/rabbitmq/.erlang.cookie"
end

cookbook_file '/var/lib/rabbitmq/.erlang.cookie' do
  source '.erlang.cookie'
  owner 'rabbitmq'
  group 'rabbitmq'
  mode '0400'
end

service 'rabbitmq-server' do
    service_name 'rabbitmq-server'
  action [:enable, :start]
end

bash "enable plugins" do
    code <<-EOH
         rabbitmq-plugins enable rabbitmq_management
         rabbitmq-plugins enable rabbitmq_management_agent
        EOH
end
