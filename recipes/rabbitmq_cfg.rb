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

template "/etc/rabbitmq/rabbitmq.config" do
    source "rabbitmq.config"
    mode '0755'
    variables ({
      :propel_backend_1 => node[:propel_rabbitmq][:propel_backend_1],
      :propel_backend_2 => node[:propel_rabbitmq][:propel_backend_2],
    }) 
        notifies :restart, 'service[rabbitmq-server]', :immediately
        notifies :run, "bash[Reset-rabbitmq-server]", :immediately
end

service 'rabbitmq-server' do
    service_name 'rabbitmq-server'
  action [:enable, :start]
end

bash "Reset-rabbitmq-server" do 
  action :nothing
  code <<-EOH
      rabbitmqctl stop_app
      rabbitmqctl reset
      rabbitmqctl start_app
      rabbitmqctl set_policy ha-all "^propel_cluster"  '{"ha-mode":"all"}'
      EOH
end
