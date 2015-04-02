execute 'yum update -y'

remote_file "#{node['chef-server']['install_path']}/#{node['chef-server']['core']['package']}" do
  source "https://#{node['chef-server']['rp1']['url']}/#{node['chef-server']['core']['package']}"
  checksum "#{node['chef-server']['core']['checksum']}"
end

directory '/etc/opscode'

template '/etc/opscode/chef-server.rb' do
  source 'chef-server.rb.erb'
end
