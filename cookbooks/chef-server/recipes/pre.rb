execute 'yum update -y'

remote_file "#{node['chef-server']['install_path']}/#{node['chef-server']['core']['package']}" do
  source "http://#{node['chef-server']['rp1']['fqdn']}/packages/#{node['chef-server']['core']['package']}"
  checksum "#{node['chef-server']['core']['checksum']}"
end

directory '/etc/opscode'

template '/etc/opscode/chef-server.rb' do
  source 'chef-server.rb.erb'
end
