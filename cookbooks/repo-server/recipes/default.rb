#
# Cookbook Name:: repo-server
# Recipe:: default
#
# Copyright (c) 2014 The Authors, All Rights Reserved.

#
#nginx install and configuration
#

#install nginx from local package
rpm_package "nginx" do
  source "#{node["repo-server"]["rpm-package"]}"
end

#service nginx setting
service 'nginx' do
  supports :status => true, :restart => true, :reload => true
end

#put nginx.conf
cookbook_file "/etc/nginx/nginx.conf" do
  source "nginx.conf"
  owner 'root'
  group 'root'
  mode '0644'
  notifies :reload, 'service[nginx]', :delayed
end

#put repo-server.conf
cookbook_file "/etc/nginx/conf.d/repo-server.conf" do
  source "repo-server.conf"
  owner 'root'
  group 'root'
  mode '0644'
  notifies :reload, 'service[nginx]', :delayed
end

bash "mv default.conf" do
  user "root"
  cwd "/etc/nginx/conf.d/"
  code "mv default.conf default.conf.org"
  only_if { File.exists?("/etc/nginx/conf.d/default.conf") }
  notifies :reload, 'service[nginx]', :delayed
end

bash "mv example_ssl.conf" do
  user "root"
  cwd "/etc/nginx/conf.d/"
  code "mv example_ssl.conf example_ssl.conf.org"
  only_if { File.exists?("/etc/nginx/conf.d/example_ssl.conf") }
  notifies :reload, 'service[nginx]', :delayed
end


#
#make directories
#

#make directories
node["repo-server"]["directories"].each do |dir|
  directory dir do
    action :create
  end
end


#
#put files
#

#put .htapasswd
cookbook_file "/etc/nginx/.htpasswd" do
  source ".htpasswd"
  owner 'nginx'
  group 'root'
  mode '0600'
  sensitive true
end

#put crt file
cookbook_file "/etc/nginx/chefrepo.cloud-platform.kddi.ne.jp.crt" do
  source "chefrepo.cloud-platform.kddi.ne.jp.crt"
  owner 'root'
  group 'root'
  mode '0644'
  sensitive true
end

#put key file
cookbook_file "/etc/nginx/chefrepo.cloud-platform.kddi.ne.jp.key" do
  source "chefrepo.cloud-platform.kddi.ne.jp.key"
  owner 'root'
  group 'root'
  mode '0600'
  sensitive true
end

#make check.html file
file "/usr/share/nginx/html/check.html" do
  content "html-check OK"
end

#put shell file
%w{ centos mackerel }.each do |target|
  template "#{node["repo-server"]["shell"]["path"]}/#{node["repo-server"]["#{target}"]["shell"]}" do
    source "#{node["repo-server"]["#{target}"]["shell"]}.erb"
    owner "root"
    group "root"
    mode 0744
    action :create
  end
end

#put logrotate file
%w{ nginx rsync wget }.each do |target|
  cookbook_file "/etc/logrotate.d/#{target}" do
    source target
    owner 'root'
    group 'root'
    mode '0644'
  end
end

#
#rsync yum mirror configure and do
#
%w{ centos mackerel }.each do |target|
  #add crontab
  ruby_block "add_crontab" do
    block do
      crondata = "#{node["repo-server"]["#{target}"]["cron"]} root sh #{node["repo-server"]["shell"]["path"]}/#{node["repo-server"]["#{target}"]["shell"]} >> #{node["repo-server"]["#{target}"]["log"]}"
      if File.open("/etc/crontab").read.index(crondata)
      else
        File.open("/etc/crontab","a"){|file|
         file.puts crondata
        }
      end
    end
  end

  #rcync mirror centos
  bash "execute shell" do
    user "root"
    code "sh #{node["repo-server"]["shell"]["path"]}/#{node["repo-server"]["#{target}"]["shell"]} >> #{node["repo-server"]["#{target}"]["log"]} &"
    only_if {node["repo-server"]["rsync"]["first"]}
  end
end
