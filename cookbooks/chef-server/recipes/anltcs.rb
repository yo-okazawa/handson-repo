execute 'yum update -y'

hostsfile_entry "#{node['chef-server']['api']['ipaddr']}" do
  hostname  "#{node['chef-server']['api']['fqdn']}"
end

hostsfile_entry "#{node['chef-server']['rp_vip']['ipaddr']}" do
  hostname  "#{node['chef-server']['rp_vip']['fqdn']}"
end

remote_file "#{node['chef-server']['install_path']}/#{node['chef-server']['anltcs']['package']}" do
  source "http://#{node['chef-server']['rp1']['fqdn']}/packages/#{node['chef-server']['anltcs']['package']}"
  checksum "#{node['chef-server']['anltcs']['checksum']}"
end

rpm_package "#{node['chef-server']['anltcs']['package']}" do
  source "#{node['chef-server']['install_path']}/#{node['chef-server']['anltcs']['package']}"
end

template '/etc/opscode-analytics/opscode-analytics.rb' do
  source 'opscode-analytics.rb.erb'
end

execute "opscode-analytics-ctl preflight-check"
execute "opscode-analytics-ctl reconfigure"
