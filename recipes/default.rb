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
      notifies   :run, 'execute[Install-rabbitmq-server]', :immediately
      notifies :run, "bash[Add-user]"
      notifies :run, "bash[env-check]"
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

bash "env-check" do
    action  :nothing
    code <<-EOH
        pid=`pidof beam.smp`
            if [ $pid -ne 0 ];then
               kill -9 $pid
               service rabbitmq-server restart
            fi
    EOH
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


