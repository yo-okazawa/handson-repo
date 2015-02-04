#
# Cookbook Name:: mysql
# Recipe:: default
#

include_recipe 'yum-repo'

#package install
package node["mysql"]["packages"] do
  action :install
end


#service enable & start
service "mysqld" do
  action [ :enable, :start ]
end

#use cookbook_file
template "#{node["mysql"]["conf-dir"]}/#{node["mysql"]["conf-file"]}" do
  source "#{node["mysql"]["template"]}"
  action :create
end


