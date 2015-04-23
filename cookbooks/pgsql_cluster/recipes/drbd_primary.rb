#
# Cookbook Name:: pgsql_cluster
# Recipe:: drbd_primary
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

package "expect"

script "service drbd start" do
  interpreter 'expect'
  code <<-EOF
    spawn service drbd start
    set timeout 1800
    expect {
      -regexp "To abort waiting enter 'yes'*" {
        exp_send "yes\n"
        exp_continue
      }
    }
  EOF
  action :nothing
end

execute "drbdadm create-md #{node["pgsql_cluster"]["resource"]}" do
  notifies :run, "script[service drbd start]", :immediately
  only_if { node["pgsql_cluster"]["res_chenge"] && !node["pgsql_cluster"]["status"] }
  action :run
end

execute "drbdadm -- --overwrite-data-of-peer primary #{node["pgsql_cluster"]["resource"]}" do
# subscribes :run, "execute[drbdadm create-md #{node["pgsql_cluster"]["resource"]}]", :immediately
  only_if " service drbd status | grep Secondary/Secondary | wc -l"
  action :run
end

execute "mke2fs -t #{node["pgsql_cluster"]["file_system"]} #{node["pgsql_cluster"]["device"]}" do
  subscribes :run, "execute[drbdadm -- --overwrite-data-of-peer primary #{node["pgsql_cluster"]["resource"]}]", :immediately
  action :nothing
end

directory "#{node["pgsql_cluster"]["mount_dir"]}" do
  action :create
end

mount "#{node["pgsql_cluster"]["mount_dir"]}" do
  device node["pgsql_cluster"]["device"]
  fstype node["pgsql_cluster"]["file_system"]
  action :mount
end