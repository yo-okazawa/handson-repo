#
# Cookbook Name:: insMysql
# Recipe:: default
#

["shared-compat","client","server"].each do |rpmStr|

  #get rpm from repoServer
  remote_file "/tmp/MySQL-#{rpmStr}-5.5.30-1.el6.x86_64.rpm" do
    source "http://10.110.42.200/packages/MySQL-#{rpmStr}-5.5.30-1.el6.x86_64.rpm"
    owner "root"
    group "root"
    mode 0644
    action :create
  end
  
  #install local rpm
  package "/tmp/MySQL-#{rpmStr}-5.5.30-1.el6.x86_64.rpm" do
    source "/tmp/MySQL-#{rpmStr}-5.5.30-1.el6.x86_64.rpm"
    action :install
  end
  
end

#service mysql start
service "mysql" do
  action [ :enable, :start ]
end

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