include_recipe "chef-server::pre"

hostsfile_entry "#{node['ipaddress']}" do
  hostname  "#{node['chef-server']['api']['fqdn']}"
  action :append
end

rpm_package "#{node['chef-server']['core']['package']}" do
  source "#{node['chef-server']['install_path']}/#{node['chef-server']['core']['package']}"
end

execute "chef-server-ctl reconfigure"

remote_file "#{node['chef-server']['install_path']}/#{node['chef-server']['manage']['package']}" do
  source "http://#{node['chef-server']['rp1']['fqdn']}/packages/#{node['chef-server']['manage']['package']}"
  checksum "#{node['chef-server']['manage']['checksum']}"
end

execute "chef-server-ctl install opscode-manage --path #{node['chef-server']['install_path']}"

execute "opscode-manage-ctl reconfigure"

cookbook_file "/var/opt/opscode/nginx/ca/chefserver.cloud-platform.kddi.ne.jp.crt" do
  source "chefserver.cloud-platform.kddi.ne.jp.crt"
end

cookbook_file "/var/opt/opscode/nginx/ca/chefserver.cloud-platform.kddi.ne.jp.key" do
  source "chefserver.cloud-platform.kddi.ne.jp.key"
end

execute "chef-server-ctl reconfigure"

include_recipe "chef-server::post"
