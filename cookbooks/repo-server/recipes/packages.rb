#
# Cookbook Name:: repo-server
# Recipe:: default
#
# Copyright (c) 2014 The Authors, All Rights Reserved.

#
#get packages
#
node["repo-server"]["packages"].each do |array|
  remote_file "#{node["repo-server"]["document-root"]}#{array[1]}/#{array[0]}" do
    source array[2]
    checksum array[3]
  end
end

