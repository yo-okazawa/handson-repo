#
# Cookbook Name:: php
# Recipe:: default
#

include_recipe 'yum-repo'

#package install
node["php"]["packages"].each do |package|
  package "#{package}" do
    action :install
  end
end

#use cookbook_file
template "#{node["php"]["conf-dir"]}/#{node["php"]["conf-file"]}" do
  source "#{node["php"]["template"]}"
  owner "root"
  group "root"
  mode 0644
  action :create
end


