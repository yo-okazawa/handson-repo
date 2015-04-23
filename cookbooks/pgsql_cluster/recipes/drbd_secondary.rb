#
# Cookbook Name:: pgsql_cluster
# Recipe:: drbd_secondary
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

service "drbd" do
  supports(
    :restart => true,
    :status => true
  )
  action :nothing
end

execute "drbdadm create-md #{node["pgsql_cluster"]["resource"]}" do
  notifies :restart, "service[drbd]", :immediately
  only_if { node["pgsql_cluster"]["res_chenge"] && !node["pgsql_cluster"]["status"] }
  action :run
end

directory "#{node["pgsql_cluster"]["mount_dir"]}" do
  action :create
end