remote_file "#{node['chef-server']['install_path']}/#{node['chef-server']['push']['package']}" do
  source "http://#{node['chef-server']['repo']['fqdn']}/#{node['chef-server']['push']['package']}"
  checksum "#{node['chef-server']['push']['checksum']}"
end

execute "chef-server-ctl install opscode-push-jobs-server --path #{node['chef-server']['install_path']}"

execute "opscode-push-jobs-server-ctl reconfigure"

remote_file "#{node['chef-server']['install_path']}/#{node['chef-server']['sync']['package']}" do
  source "http://#{node['chef-server']['repo']['fqdn']}/#{node['chef-server']['sync']['package']}"
  checksum "#{node['chef-server']['sync']['checksum']}"
end

execute "chef-server-ctl install chef-sync --path #{node['chef-server']['install_path']}"

# execute "chef-sync-ctl reconfigure"

execute "chef-server-ctl reconfigure"
