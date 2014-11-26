include_recipe "chef-server::pre"

remote_file "#{node['chef-server']['install_path']}/#{node['chef-server']['drbd84-utils']['package']}" do
  source "http://#{node['chef-server']['repo']['url']}/#{node['chef-server']['drbd84-utils']['package']}"
  checksum "#{node['chef-server']['drbd84-utils']['checksum']}"
end

rpm_package "#{node['chef-server']['drbd84-utils']['package']}" do
  source "#{node['chef-server']['install_path']}/#{node['chef-server']['drbd84-utils']['package']}"
end

remote_file "#{node['chef-server']['install_path']}/#{node['chef-server']['kmod-drbd84']['package']}" do
  source "http://#{node['chef-server']['repo']['url']}/#{node['chef-server']['kmod-drbd84']['package']}"
  checksum "#{node['chef-server']['kmod-drbd84']['checksum']}"
end

rpm_package "#{node['chef-server']['kmod-drbd84']['package']}" do
  source "#{node['chef-server']['install_path']}/#{node['chef-server']['kmod-drbd84']['package']}"
end

rpm_package "#{node['chef-server']['core']['package']}" do
  source "#{node['chef-server']['install_path']}/#{node['chef-server']['core']['package']}"
end

execute "chef-server-ctl reconfigure"

include_recipe "chef-server::post"
