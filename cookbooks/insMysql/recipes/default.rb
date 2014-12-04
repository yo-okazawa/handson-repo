#
# Cookbook Name:: insMysql
# Recipe:: default
#
# Copyright (c) 2014 The Authors, All Rights Reserved.


package "mysql-server" do
  action :install
end

service "mysqld" do
  action [ :enable, :start ]
end



