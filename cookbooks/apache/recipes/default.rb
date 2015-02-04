#
# Cookbook Name:: apache
# Recipe:: default
#

include_recipe 'yum-repo'

#package install
package "#{node["apache"]["package"]}" do
  action :install
end

#service enable & start
service "httpd" do
  action [ :enable, :start ]
end

#use cookbook_file
template "#{node["apache"]["conf-dir"]}/#{node["apache"]["conf-file"]}" do
  source "#{node["apache"]["template"]}"
  owner "root"
  group "root"
  mode 0644
  action :create
  notifies :reload, "service[httpd]"
end


