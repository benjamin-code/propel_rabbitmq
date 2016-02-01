service 'rabbitmq-server' do
    service_name 'rabbitmq-server'
  action [:enable, :start]
end

template "/etc/rabbitmq/rabbitmq.config" do
    source "rabbitmq.config"
    mode '0755'
    variables ({
      :propel_backend_1 => node[:propel_rabbitmq][:propel_backend_1],
      :propel_backend_2 => node[:propel_rabbitmq][:propel_backend_2],
      :propel_cert_path => node[:propel_nginx][:propel_cert_path],
      :propel_key_path => node[:propel_nginx][:propel_key_path],
    }) 
        notifies :restart, 'service[rabbitmq-server]', :immediately
        notifies :run, "bash[Reset-rabbitmq-server]", :immediately
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

#Add new user for propel, and grant admin privilege, and set full permission for vhost "/". Do it in both nodes

execute "Add-user" do
   user "root"
   command <<-EOH
                  rabbitmqctl add_user rabbit_sx propel2014
                  rabbitmqctl set_user_tags rabbit_sx administrator
                  rabbitmqctl set_permissions -p / rabbit_sx ".*" ".*" ".*"
             EOH
   not_if "rabbitmqctl list_users | grep rabbit_sx"
end