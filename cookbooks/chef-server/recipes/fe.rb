include_recipe "chef-server::pre"

template '/etc/opscode/chef-server.rb' do
  source 'chef-server.rb.erb'
  variables({:api_fqdn => node['fqdn']})
end

rpm_package "#{node['chef-server']['core']['package']}" do
  source "#{node['chef-server']['install_path']}/#{node['chef-server']['core']['package']}"
end

execute "chef-server-ctl reconfigure"

remote_file "#{node['chef-server']['install_path']}/#{node['chef-server']['manage']['package']}" do
  source "http://#{node['chef-server']['repo']['url']}/#{node['chef-server']['manage']['package']}"
  checksum "#{node['chef-server']['manage']['checksum']}"
end

execute "chef-server-ctl install opscode-manage --path #{node['chef-server']['install_path']}"

execute "opscode-manage-ctl reconfigure"

execute "chef-server-ctl reconfigure"

include_recipe "chef-server::post"
