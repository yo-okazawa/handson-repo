remote_file "#{node['chef-server']['install_path']}/#{node['chef-server']['report']['package']}" do
  source "http://#{node['chef-server']['rp1']['fqdn']}/packages/#{node['chef-server']['report']['package']}"
  checksum "#{node['chef-server']['report']['checksum']}"
end

execute "chef-server-ctl install opscode-reporting --path #{node['chef-server']['install_path']}"

execute "opscode-reporting-ctl reconfigure"

execute "chef-server-ctl reconfigure"
