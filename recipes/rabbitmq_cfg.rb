template "/etc/rabbitmq/rabbitmq.config" do
    source "rabbitmq.config"
    mode '0755'
    variables ({
      :propel_backend_1 => node[:propel_rabbitmq][:propel_backend_1],
      :propel_backend_2 => node[:propel_rabbitmq][:propel_backend_2],
    })
end

bash "Start and reset rabbitmq-server" do 
#  action :nothing
  code <<-EOH
      /etc/rc.d/init.d/rabbitmq-server restart
      rabbitmqctl stop_app
      rabbitmqctl reset
      rabbitmqctl start_app
      rabbitmqctl set_policy ha-all "^propel_cluster"  '{"ha-mode":"all"}'
      EOH
end
