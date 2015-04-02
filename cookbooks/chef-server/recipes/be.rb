include_recipe "chef-server::drbd"

execute "chef-server-ctl reconfigure"

remote_file "#{node['chef-server']['install_path']}/#{node['chef-server']['push']['package']}" do
  source "https://#{node['chef-server']['rp1']['url']}/#{node['chef-server']['push']['package']}"
  checksum "#{node['chef-server']['push']['checksum']}"
end

execute "chef-server-ctl install opscode-push-jobs-server --path #{node['chef-server']['install_path']}"

execute "opscode-push-jobs-server-ctl reconfigure"

execute "chef-server-ctl reconfigure"

include_recipe "chef-server::post"
