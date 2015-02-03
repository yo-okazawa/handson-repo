#
# Cookbook Name:: repo-server
# Recipe:: default
#
# Copyright (c) 2014 The Authors, All Rights Reserved.

#install nginx from local package
rpm_package "nginx" do
  source "#{node["repo-server"]["rpm-package"]}"
end

#put crt file
cookbook_file "/etc/nginx/chefrepo.cloud-platform.kddi.ne.jp.crt" do
  source "chefrepo.cloud-platform.kddi.ne.jp.crt"
end

#put key file
cookbook_file "/etc/nginx/chefrepo.cloud-platform.kddi.ne.jp.key" do
  source "chefrepo.cloud-platform.kddi.ne.jp.key"
end

#put nginx conf
cookbook_file "/etc/nginx/conf.d/example_ssl.conf" do
  source "example_ssl.conf"
end

#make check.html file
file "/usr/share/nginx/html/check.html" do
  content "html-check OK"
end

#service nginx setting
service 'nginx' do
  supports :status => true, :restart => true, :reload => true
  action [:enable, :start, :reload]
end

#make packages dir
directory "/usr/share/nginx/html/packages" do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

#make mirror dir
directory "#{node["repo-server"]["dastination"]}" do
  action :create
end

template "#{node["repo-server"]["shell"]}" do
  source "rsync-centos-yum-mirror.sh.erb"
  owner "root"
  group "root"
  mode 0744
  action :create
end

#rcync mirror
bash "rsync mirror" do
  user "root"
  code "sh #{node["repo-server"]["shell"]} >> #{node["repo-server"]["log"]} &"
end

#add crontab
ruby_block "add_crontab" do
  block do
    crondata = "10 2 * * * root sh #{node["repo-server"]["shell"]} >> #{node["repo-server"]["log"]}"
    if File.open("/etc/crontab").read.index(crondata)
      File.write("/tmp/test.txt", "a")
    else
      File.open("/etc/crontab","a"){|file|
       file.puts crondata
      }
    end
  end
end
