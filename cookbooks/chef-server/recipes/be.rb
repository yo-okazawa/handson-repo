include_recipe "chef-server::pre"

chef_gem 'open4' do
  source "#{node['chef-server']['install_path']}/#{node['chef-server']['open4']['gem']}"
end

chef_gem 'di-ruby-lvm-attrib' do
  source "#{node['chef-server']['install_path']}/#{node['chef-server']['lvm_attr']['gem']}"
end

chef_gem 'di-ruby-lvm' do
  source "#{node['chef-server']['install_path']}/#{node['chef-server']['lvm']['gem']}"
end

lvm_physical_volume "#{node['chef-server']['lvm_physical_volume']}"

lvm_volume_group 'opscode' do
  physical_volumes ["#{node['chef-server']['lvm_physical_volume']}"]
  logical_volume 'drbd' do
    size        '80%VG'
  end
end

remote_file "#{node['chef-server']['install_path']}/#{node['chef-server']['drbd84-utils']['package']}" do
  source "http://#{node['chef-server']['repo1']['fqdn']}/#{node['chef-server']['drbd84-utils']['package']}"
  checksum "#{node['chef-server']['drbd84-utils']['checksum']}"
end

rpm_package "#{node['chef-server']['drbd84-utils']['package']}" do
  source "#{node['chef-server']['install_path']}/#{node['chef-server']['drbd84-utils']['package']}"
end

remote_file "#{node['chef-server']['install_path']}/#{node['chef-server']['kmod-drbd84']['package']}" do
  source "http://#{node['chef-server']['repo1']['fqdn']}/#{node['chef-server']['kmod-drbd84']['package']}"
  checksum "#{node['chef-server']['kmod-drbd84']['checksum']}"
end

rpm_package "#{node['chef-server']['kmod-drbd84']['package']}" do
  source "#{node['chef-server']['install_path']}/#{node['chef-server']['kmod-drbd84']['package']}"
end

rpm_package "#{node['chef-server']['core']['package']}" do
  source "#{node['chef-server']['install_path']}/#{node['chef-server']['core']['package']}"
end

execute "chef-server-ctl reconfigure"
