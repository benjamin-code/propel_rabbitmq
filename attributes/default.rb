
# can override in recipes
default[:propel_rabbitmq][:user] = 'rabbitmq'
default[:propel_rabbitmq][:user_id] = 5002
default[:propel_rabbitmq][:user_shell] = '/bin/bash'
default[:propel_rabbitmq][:user_home] = '/home/rabbitmq'
default[:propel_rabbitmq][:user_password] = 'rabbitmq'
default[:propel_rabbitmq][:group] = 'rabbitmq'
default[:propel_rabbitmq][:group_id] = 5002

default[:propel_rabbitmq][:nginx_for_ui] = "15.107.13.58"
default[:propel_rabbitmq][:nginx_for_backend] = "15.107.12.41"
default[:propel_rabbitmq][:propel_ui_1] = "propel-ha-3"
default[:propel_rabbitmq][:propel_ui_2] = "propel-ha-4"
default[:propel_rabbitmq][:propel_backend_1] = "15.107.13.37"
default[:propel_rabbitmq][:propel_backend_2] = "15.107.13.40"
default[:propel_rabbitmq][:propel_backend_1_name] = "centos6-2"

default[:propel_rabbitmq][:postgres_1] = "propel-ha-7"
default[:propel_rabbitmq][:postgres_2] = "propel-ha-8"

