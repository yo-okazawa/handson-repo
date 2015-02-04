#
# Cookbook Name:: yum-repo
# Recipe:: default
#
template "/etc/yum.repos.d/cent5-chefrepo.repo" do
  source "cent5-chefrepo.repo.erb"
  owner "root"
  group "root"
  mode 0644
  action :create
  only_if {node["platform"] == "centos" && node["platform_version"][0] == "5"}
end

template "/etc/yum.repos.d/cent6-chefrepo.repo" do
  source "cent6-chefrepo.repo.erb"
  owner "root"
  group "root"
  mode 0644
  action :create
  only_if {node["platform"] == "centos" && node["platform_version"][0] == "6"}
end
print "plat version is " + node["platform_version"][0]
print node["platform"] == "centos" && node["platform_version"][0] == 6