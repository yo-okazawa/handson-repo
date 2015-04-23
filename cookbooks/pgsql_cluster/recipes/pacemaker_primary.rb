#
# Cookbook Name:: pgsql_cluster
# Recipe:: pacemaker_primary
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

template "/tmp/pcs.sh" do
  source "pcs.sh.erb"
  action :create
  mode "755"
end

execute "/tmp/pcs.sh" do
  action :run
end

