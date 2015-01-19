#
# Cookbook Name:: workstation
# Recipe:: default
#

#make chef dir
directory "#{node["workstation"]["template-dir"]}" do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

#make gems dir
directory "#{node["workstation"]["gem-dir"]}" do
  owner 'root'
  group 'root'
  mode '0644'
  action :create
end

#get custum-template from repo-server
node["workstation"]["template"].each do |file|
  remote_file "#{node["workstation"]["template-dir"]}/#{file}" do
    source "#{node["workstation"]["repo-url"]}/#{node["workstation"]["repo-template"]}/#{file}"
    owner "root"
    group "root"
    mode 0644
    action :create
  end
end

#get gem from repo-server
node["workstation"]["gem-list"].each do |gem|
  remote_file "#{node["workstation"]["gem-dir"]}/#{gem}" do
    source "#{node["workstation"]["repo-url"]}/#{node["workstation"]["repo-gem"]}/#{gem}"
    owner "root"
    group "root"
    mode 0644
    action :create
  end
end

#install gem from local
execute "Install gems" do
  cwd "#{node["workstation"]["gem-dir"]}"
  command "/opt/chef/embedded/bin/gem install --local --no-rdoc --no-ri knife-push knife-reporting"
  action :run
end

