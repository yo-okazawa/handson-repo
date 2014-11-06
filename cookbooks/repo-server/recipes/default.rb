#
# Cookbook Name:: repo-server
# Recipe:: default
#
# Copyright (c) 2014 The Authors, All Rights Reserved.
rpm_package "nginx" do
  source "/tmp/nginx-1.7.7-1.el6.ngx.x86_64.rpm"
end

service 'nginx' do
  supports :status => true, :restart => true, :reload => true
  action [:enable, :start]
end
