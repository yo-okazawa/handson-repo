#
# Cookbook Name:: pgsql_cluster
# Recipe:: pgsql_common
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

node["pgsql_cluster"]["pgsql_packages"].each do |package|
  package package
end

template "/var/lib/pgsql/.bash_profile" do
  source "bash_profile.erb"
  action :create
end

template "/etc/init.d/postgresql" do
  source "postgresql.erb"
  action :create
end
