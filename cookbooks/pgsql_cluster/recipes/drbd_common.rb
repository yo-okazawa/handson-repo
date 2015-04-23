#
# Cookbook Name:: pgsql_cluster
# Recipe:: drbd_common
#
# Copyright (c) 2015 The Authors, All Rights Reserved.
%w{ drbd-utils kmod-drbd }.each do |package|
  remote_file "/tmp/#{node["pgsql_cluster"]["#{package}"]}" do
    source "#{node["pgsql_cluster"]["reposerver_url"]}/#{node["pgsql_cluster"]["#{package}"]}"
  end

  rpm_package "/tmp/#{node["pgsql_cluster"]["#{package}"]}"
end

=begin
%w{ "10.110.42.202  pos1" "10.110.42.206  pos2" }.each do |target|
  execute "echo #{target} >> /etc/hosts"
    not_if "cat /etc/hosts | grep '#{target}' | wc -l"
  end
end
=end

template "/etc/drbd.d/#{node["pgsql_cluster"]["resource"]}.res" do
  source "resource.res.erb"
  action :create
end

template "/etc/drbd.d/global_common.conf" do
  source "global_common.conf.erb"
  action :create
end

ruby_block "res chenged check" do
  block do
    node.default["pgsql_cluster"]["res_chenge"] = true
  end
  subscribes :run, "template[/etc/drbd.d/#{node["pgsql_cluster"]["resource"]}.res]", :immediately
  action :nothing
end

ruby_block "drbd status check" do
  block do
    overview = `drbd-overview | grep 'drbd not loaded' | wc -l`
    if overview > 0
      node.default["pgsql_cluster"]["status"] = true
    else
      node.default["pgsql_cluster"]["status"] = false
    end
  end
  action :nothing
end
