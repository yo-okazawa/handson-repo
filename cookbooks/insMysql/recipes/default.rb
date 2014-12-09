#
# Cookbook Name:: insMysql
# Recipe:: default
#
node["mysql"]["rpmList"].each do |rpmFile|

  #get rpm from repoServer
  remote_file "#{node["target"]["insDir"]}/#{rpmFile}" do
    source "#{node["repo"]["url"]}/#{rpmFile}"
    owner "root"
    group "root"
    mode 0644
    action :create
  end
  
  #install local rpm
  rpm_package "#{node["target"]["insDir"]}/#{rpmFile}" do
    source "#{node["target"]["insDir"]}/#{rpmFile}"
    action :install
  end
  
end

#use cookbook_file
cookbook_file "#{node["mysql"]["cnfFile"]}" do
  path "#{node["mysql"]["cnfDir"]}/#{node["mysql"]["cnfFile"]}"
  owner "root"
  group "root"
  mode 0644
  action :create
  notifies :reload, 'service[mysql]'
end

#service mysql start
service "mysql" do
  action [ :enable, :start ]
end




=begin
#use tamplate
template "my.cnf" do
 path "/etc/my.cnf"
 owner "root"
 group "root"
 mode 0644
 notifies :reload, 'service[mysql]'
end
=end

#----------------second test----------------
=begin

#get rpm from repoServer(shared-compat)
remote_file "/tmp/MySQL-shared-compat-5.5.30-1.el6.x86_64.rpm" do
  source "http://10.110.42.200/packages/MySQL-shared-compat-5.5.30-1.el6.x86_64.rpm"
  owner "root"
  group "root"
  mode 0644
  action :create
end

#get rpm from repoServer(MySQL-client)
remote_file "/tmp/MySQL-client-5.5.30-1.el6.x86_64.rpm" do
  source "http://10.110.42.200/packages/MySQL-client-5.5.30-1.el6.x86_64.rpm"
  owner "root"
  group "root"
  mode 0644
  action :create
end

#get rpm from repoServer(MySQL-server)
remote_file "/tmp/MySQL-server-5.5.30-1.el6.x86_64.rpm" do
  source "http://10.110.42.200/packages/MySQL-server-5.5.30-1.el6.x86_64.rpm"
  owner "root"
  group "root"
  mode 0644
  action :create
end

#install local rpm(shared-compat)
package "/tmp/MySQL-shared-compat-5.5.30-1.el6.x86_64.rpm" do
  source "/tmp/MySQL-shared-compat-5.5.30-1.el6.x86_64.rpm"
  action :install
end

#install local rpm(MySQL-client)
package "/tmp/MySQL-client-5.5.30-1.el6.x86_64.rpm" do
  source "/tmp/MySQL-client-5.5.30-1.el6.x86_64.rpm"
  action :install
end

#install local rpm(MySQL-server)
package "/tmp/MySQL-server-5.5.30-1.el6.x86_64.rpm" do
  source "/tmp/MySQL-server-5.5.30-1.el6.x86_64.rpm"
  action :install
end

#service mysql start
service "mysql" do
  action [ :enable, :start ]
end

=end


#----------------first test----------------
=begin

#test get rpm from repoServer
remote_file "/tmp/chef-11.16.4-1.el6.x86_64.rpm" do
  source "http://10.110.42.200/packages/chef-11.16.4-1.el6.x86_64.rpm"
  owner "root"
  group "root"
  mode 0644
  action :create
end
#test install local rpm
package "/tmp/chef-11.16.4-1.el6.x86_64.rpm" do
  source "/tmp/chef-11.16.4-1.el6.x86_64.rpm"
  action :install
end
package "mysql-server" do
  action :install
end
service "mysqld" do
  action [ :enable, :start ]
end

=end