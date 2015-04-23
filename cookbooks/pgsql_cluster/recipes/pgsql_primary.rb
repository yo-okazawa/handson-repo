#
# Cookbook Name:: pgsql_cluster
# Recipe:: pgsql_primary
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

directory "#{node["pgsql_cluster"]["pgsql_directory"]}" do
  owner "postgres"
  group "postgres"
  action :create
end

execute "initdb --encoding=UTF-8 -D #{node["pgsql_cluster"]["pgsql_directory"]}" do
  user "postgres"
  not_if { File.exists?("#{node["pgsql_cluster"]["pgsql_directory"]}/postgresql.conf") }
end

