#
# Cookbook Name:: mysql
# Recipe:: default
#
node["mysql"]["package-list"].each do |package|

  #get rpm from repoServer
  remote_file "#{node["mysql"]["package-dir"]}/#{package}" do
    source "#{node["mysql"]["repo-url"]}/#{package}"
    owner "root"
    group "root"
    mode 0644
    action :create
  end
  
  #install local rpm
  rpm_package "#{node["mysql"]["package-dir"]}/#{package}" do
    source "#{node["mysql"]["package-dir"]}/#{package}"
    action :install
  end
  
end

#use cookbook_file
template "#{node["mysql"]["cnf-file"]}" do
  source "#{node["mysql"]["erb-file"]}"
  owner "root"
  group "root"
  mode 0644
  action :create
  notifies :reload, 'service[mysql]'
end

#service mysql start
service "mysql" do
  action [ :enable, :start ]
end

