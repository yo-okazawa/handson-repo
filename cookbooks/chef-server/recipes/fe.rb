remote_file "#{node['chef-server']['install_path']}/#{node['chef-server']['manage']['package']}" do
  source "http://#{node['chef-server']['repo1']['fqdn']}/#{node['chef-server']['manage']['package']}"
  checksum "#{node['chef-server']['manage']['checksum']}"
end

execute "chef-server-ctl install opscode-manage --path #{node['chef-server']['install_path']}"

execute "opscode-manage-ctl reconfigure"

execute "chef-server-ctl reconfigure"
