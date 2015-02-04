#
# Cookbook Name:: wordpress
# Recipe:: default
#

include_recipe 'lamp'

#for wordpress key
require 'openssl'
def secure_password(length = 20)
  pw = String.new
  while pw.length < length
    pw << ::OpenSSL::Random.random_bytes(1).gsub(/\W/, '')
  end
  pw
end

remote_file "/tmp/#{node["wordpress"]["package"]}" do
  source "#{node["wordpress"]["package-url"]}"
  owner 'root'
  group 'root'
  mode '0644'
end

#make wordpress dir
directory "#{node["wordpress"]["documentroot"]}/#{node["wordpress"]["wordpressroot"]}/" do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

#deploy package
bash 'deploy_package' do
  cwd "/tmp"
  code <<-EOH
    tar -xzvf #{node["wordpress"]["package"]}
    cp -a wordpress/* #{node["wordpress"]["documentroot"]}/#{node["wordpress"]["wordpressroot"]}/
    EOH
  not_if { ::File.exists?("/var/www/html/wdp/index.php") }
end

#set wordpress key
node.set_unless["wordpress"]["keys"]["auth"] = secure_password
node.set_unless["wordpress"]["keys"]["secure_auth"] = secure_password
node.set_unless["wordpress"]["keys"]["logged_in"] = secure_password
node.set_unless["wordpress"]["keys"]["nonce"] = secure_password
node.set_unless["wordpress"]["salt"]["auth"] = secure_password
node.set_unless["wordpress"]["salt"]["secure_auth"] = secure_password
node.set_unless["wordpress"]["salt"]["logged_in"] = secure_password
node.set_unless["wordpress"]["salt"]["nonce"] = secure_password

#make wp-config.php
template "#{node["wordpress"]["documentroot"]}/#{node["wordpress"]["wordpressroot"]}/#{node["wordpress"]["wp-config"]["name"]}" do
  source node["wordpress"]["wp-config"]["erb"]
  owner "root"
  group "root"
  action :create
end

#set mysql query
execute "create-db" do
  command "mysql < #{node["wordpress"]["sql"]["path"]}/#{node["wordpress"]["sql"]["name"]}"
  action :nothing
end

#make create-wordpress.sql
template "#{node["wordpress"]["sql"]["path"]}/#{node["wordpress"]["sql"]["name"]}" do
  source node["wordpress"]["sql"]["erb"]
  owner "root"
  group "root"
  action :create
  notifies :run, "execute[create-db]", :immediately
end