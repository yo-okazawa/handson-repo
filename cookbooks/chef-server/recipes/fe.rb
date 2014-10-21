include_recipe "chef-server::pre"

rpm_package "#{node['chef-server']['core']['package']}" do
  source "#{node['chef-server']['install_path']}/#{node['chef-server']['core']['package']}"
end

execute "chef-server-ctl reconfigure"

remote_file "#{node['chef-server']['install_path']}/#{node['chef-server']['manage']['package']}" do
  source "http://#{node['chef-server']['repo1']['fqdn']}/#{node['chef-server']['manage']['package']}"
  checksum "#{node['chef-server']['manage']['checksum']}"
end

execute "chef-server-ctl install opscode-manage --path #{node['chef-server']['install_path']}"

execute "opscode-manage-ctl reconfigure"

remote_file "#{node['chef-server']['install_path']}/#{node['chef-server']['report']['package']}" do
  source "http://#{node['chef-server']['repo1']['fqdn']}/#{node['chef-server']['report']['package']}"
  checksum "#{node['chef-server']['report']['checksum']}"
end

execute "chef-server-ctl install opscode-reporting --path #{node['chef-server']['install_path']}"

execute "opscode-reporting-ctl reconfigure"

include_recipe "chef-server::post"
