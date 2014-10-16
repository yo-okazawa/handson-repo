execute 'yum update -y'

remote_file "#{node['chef-server']['install_path']}/#{node['chef-server']['core']['package']}" do
  source "http://#{node['chef-server']['repo1']['fqdn']}/#{node['chef-server']['core']['package']}"
  checksum "#{node['chef-server']['core']['checksum']}"
end

directory '/etc/opscode'

template '/etc/opscode/chef-server.rb' do
  source 'chef-server.rb.erb'
end

rpm_package "#{node['chef-server']['core']['package']}" do
  source "#{node['chef-server']['install_path']}/#{node['chef-server']['core']['package']}"
end

execute "chef-server-ctl reconfigure"
