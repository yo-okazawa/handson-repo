chef_gem 'open4' do
  source "#{node['chef-server']['install_path']}/#{node['chef-server']['open4']['gem']}"
  action :upgrade
end

chef_gem 'di-ruby-lvm-attrib' do
  source "#{node['chef-server']['install_path']}/#{node['chef-server']['lvm_attr']['gem']}"
  action :upgrade
end

chef_gem 'di-ruby-lvm' do
  source "#{node['chef-server']['install_path']}/#{node['chef-server']['lvm']['gem']}"
  action :upgrade
end

lvm_physical_volume "#{node['chef-server']['lvm_physical_volume']}"

lvm_volume_group 'opscode' do
  physical_volumes ["#{node['chef-server']['lvm_physical_volume']}"]
  logical_volume 'drbd' do
    size        '80%VG'
  end
end
