#
# Cookbook Name:: repo-server
# Recipe:: default
#
# Copyright (c) 2014 The Authors, All Rights Reserved.

#
#get packages
#

node["repo-server"]["packages"].each do |array|
  remote_file "#{node["repo-server"]["packages_dir"]}/#{array[0]}" do
    source "#{array[1]}/#{array[0]}"
  end
end


#
#get other-packages
#

node["repo-server"]["other_packages"].each do |array|
  remote_file "#{node["repo-server"]["other_packages_dir"]}/#{array[0]}" do
    source "#{array[1]}/#{array[0]}"
  end
end


#
#get gems
#

node["repo-server"]["gems"].each do |array|
  execute "gem get #{array[0]}" do
    cwd node["repo-server"]["gem_dir"]
    command "/opt/chef/embedded/bin/gem fetch #{array[0]} -v #{array[1]}"
    action :run
    not_if { ::File.exists?("#{node["repo-server"]["gem_dir"]}/#{array[0]}-#{array[1]}.gem") }
  end
end