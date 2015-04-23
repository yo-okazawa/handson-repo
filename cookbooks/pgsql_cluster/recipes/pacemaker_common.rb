#
# Cookbook Name:: pgsql_cluster
# Recipe:: pacemaker_common
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

%w{ pacemaker corosync pcs }.each do | yum_package |
  package yum_package do
    action :install
  end
end

service "corosync" do
  supports(
    :restart => true,
    :status => true
  )
  action :nothing
end

template "/etc/corosync/corosync.conf" do
  source "corosync.conf.erb"
  action :create
  notifies :restart, "service[corosync]", :immediately
end

service "drbd" do
  action [:disable, :stop]
end

service "postgresql-server" do
  action [:disable, :stop]
end
