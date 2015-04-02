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
  action [ :enable, :start ]
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
#install packages
#

%w{ createrepo yum-utils }.each do |target|
  package target do
    action :install
  end
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

#make check.html file
file "/usr/share/nginx/html/packages/check.html" do
  content "html-check OK"
end

#put shell file
%w{ centos mackerel-rpm mackerel-msi mackerel-tgz backup mackerel-yum }.each do |target|
  template "#{node["repo-server"]["shell"]["path"]}/#{node["repo-server"]["#{target}"]["shell"]}" do
    source "#{node["repo-server"]["#{target}"]["shell"]}.erb"
    owner "root"
    group "root"
    mode 0744
    action :create
  end
end

#put shell file
%w{ repo-server-check.sh repo-client-check.sh }.each do |target|
  cookbook_file "#{node["repo-server"]["shell"]["path"]}/#{target}" do
    source target
    owner "root"
    group "root"
    mode 0744
    action :create
  end
end

#put shell file
cookbook_file "#{node["repo-server"]["mackerel"]["dastination"]}/#{node["repo-server"]["mackerel-set"]["shell"]}" do
  source #{node["repo-server"]["mackerel-set"]["shell"]}
  owner "root"
  group "root"
  mode 0644
  action :create
end

#put logrotate file
%w{ nginx rsync mackerel backup }.each do |target|
  cookbook_file "/etc/logrotate.d/#{target}" do
    source target
    owner 'root'
    group 'root'
    mode '0644'
  end
end

#put mackerel.repo file
cookbook_file "/etc/yum.repos.d/mackerel.repo" do
  source 'mackerel.repo'
  owner 'root'
  group 'root'
  mode '0644'
end

#
#rsync yum mirror configure and do
#

#add crontab
%w{ mackerel-msi mackerel-tgz mackerel-rpm mackerel-yum centos backup }.each do |target|
  ruby_block "add_crontab" do
    block do
      crondata = "#{node["repo-server"]["#{target}"]["cron"]} root sh #{node["repo-server"]["shell"]["path"]}/#{node["repo-server"]["#{target}"]["shell"]} >> #{node["repo-server"]["#{target}"]["log-directory"]}/#{node["repo-server"]["#{target}"]["log"]} 2>&1"
      if File.open("/etc/crontab").read.index(crondata)
      else
        File.open("/etc/crontab","a"){|file|
         file.puts crondata
        }
      end
    end
  end
end

#rcync mirror centos
bash "execute rsync shell" do
  user "root"
  code "sh #{node["repo-server"]["shell"]["path"]}/#{node["repo-server"]["centos"]["shell"]} >> #{node["repo-server"]["centos"]["log"]} &"
  only_if {node["repo-server"]["rsync"]["first"]}
end

#get mackerel
%w{ mackerel-rpm mackerel-msi mackerel-tgz }.each do |target|
  remote_file "#{node["repo-server"]["#{target}"]["dastination"]}/#{node["repo-server"]["#{target}"]["package"]}" do
    source "#{node["repo-server"]["#{target}"]["source"]}/#{node["repo-server"]["#{target}"]["package"]}"
  end
end

bash "execute mackerel shell" do
  user "root"
  code "sh #{node["repo-server"]["shell"]["path"]}/#{node["repo-server"]["mackerel-yum"]["shell"]} >> #{node["repo-server"]["mackerel-yum"]["log-directory"]}/#{node["repo-server"]["mackerel-yum"]["log"]} &"
  only_if {node["repo-server"]["rsync"]["first"]}
end