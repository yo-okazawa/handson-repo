execute 'yum update -y'

remote_file "#{node['chef-server']['install_path']}/#{node['chef-server']['anltcs']['package']}" do
  source "http://#{node['chef-server']['repo1']['fqdn']}/#{node['chef-server']['anltcs']['package']}"
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
