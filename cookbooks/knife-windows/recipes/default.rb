#
# Cookbook Name:: knife-windows
# Recipe:: default
#

#make gems dir
directory "#{node["knife-windows"]["gem-dir"]}" do
  owner 'root'
  group 'root'
  mode '0644'
  action :create
end

#install pkg from yum-repo
node["knife-windows"]["package"].each do |package|
  package "#{package}" do
    action :install
  end
end

#get gem from repoServer
node["knife-windows"]["gem-list"].each do |gem|
  remote_file "#{node["knife-windows"]["gem-dir"]}/#{gem}" do
    source "#{node["knife-windows"]["repo-url"]}/#{node["knife-windows"]["repo-gem"]}/#{gem}"
    owner "root"
    group "root"
    mode 0644
    action :create
  end
end

#install gem from local
execute "Install gems" do
  cwd "#{node["knife-windows"]["gem-dir"]}"
  command "/opt/chef/embedded/bin/gem install --local --no-rdoc --no-ri knife-windows"
  action :run
end

#gem cleanup
execute "/opt/chef/embedded/bin/gem cleanup"