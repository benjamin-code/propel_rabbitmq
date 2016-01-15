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
end

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

if ( node.hostname =~ /atc(.*)/ )
  yum_package 'rabbitmq-server' do
    action :install
    flush_cache [ :before ]
  end
end

service 'rabbitmq-server' do
    service_name 'rabbitmq-server'
  action [:enable, :start]
end



