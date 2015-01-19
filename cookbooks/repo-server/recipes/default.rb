#
# Cookbook Name:: repo-server
# Recipe:: default
#
# Copyright (c) 2014 The Authors, All Rights Reserved.
rpm_package "nginx" do
  source "/tmp/nginx-1.7.9-1.el6.ngx.x86_64.rpm"
end

cookbook_file "/etc/nginx/chefrepo.cloud-platform.kddi.ne.jp.crt" do
  source "chefrepo.cloud-platform.kddi.ne.jp.crt"
end

cookbook_file "/etc/nginx/chefrepo.cloud-platform.kddi.ne.jp.key" do
  source "chefrepo.cloud-platform.kddi.ne.jp.key"
end

cookbook_file "/etc/nginx/conf.d/example_ssl.conf" do
  source "example_ssl.conf"
end

file "/usr/share/nginx/html/check.html" do
  content IO.read("/usr/share/nginx/html/index.html")
end

service 'nginx' do
  supports :status => true, :restart => true, :reload => true
  action [:enable, :start, :reload]
end
