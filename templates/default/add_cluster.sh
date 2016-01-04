#!/bin/sh
rabbitmqctl stop_app
rabbitmqctl join_cluster rabbit@<%= @clustermaster %>
rabbitmqctl start_app
rabbitmqctl set_policy ha-all "^propel_cluster"  '{"ha-mode":"all"}'
rabbitmq-plugins enable rabbitmq_management_agent
