#
# Cookbook Name:: sql-server
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

#
#set command line option
#

config_option = "/q "
config_option << "/IACCEPTSQLSERVERLICENSETERMS "
config_option << "/ACTION=install "
config_option << "/FEATURES=SQL,AS,RS,DQC,IS,MDS,Tools "
config_option << "/INSTANCENAME=MSSQLSERVER "
config_option << "/SECURITYMODE=SQL "
config_option << "/SAPWD=\"#{node['sql_server']['password']}\" "

config_option << "/SQLSVCACCOUNT=\"#{node['sql_server']['hostname']}\\#{node['sql_server']['user']}\" "
config_option << "/SQLSVCPASSWORD=\"#{node['sql_server']['password']}\" "
config_option << "/SQLSYSADMINACCOUNTS=\"#{node['sql_server']['hostname']}\\#{node['sql_server']['user']}\" "
config_option << "/AGTSVCACCOUNT=\"#{node['sql_server']['hostname']}\\#{node['sql_server']['user']}\" "
config_option << "/AGTSVCPASSWORD=\"#{node['sql_server']['password']}\" "

config_option << "/ASSYSADMINACCOUNTS=\"#{node['sql_server']['hostname']}\\#{node['sql_server']['user']}\" "
config_option << "/ASSVCACCOUNT=\"#{node['sql_server']['hostname']}\\#{node['sql_server']['user']}\" "
config_option << "/ASSVCPASSWORD=\"#{node['sql_server']['password']}\" "

config_option << "/RSSVCACCOUNT=\"#{node['sql_server']['hostname']}\\#{node['sql_server']['user']}\" "
config_option << "/RSSVCPASSWORD=\"#{node['sql_server']['password']}\" "

config_option << "/ISSVCAccount=\"#{node['sql_server']['hostname']}\\#{node['sql_server']['user']}\" "
config_option << "/ISSVCPASSWORD=\"#{node['sql_server']['password']}\" "


#
#sql server install
#

windows_package node['sql_server']['package_name'] do
  source node['sql_server']['url']
  checksum node['sql_server']['checksum']
  timeout node['sql_server']['installer_timeout']
  installer_type :custom
  options "#{config_option}"
  action :install
end


#
#open firewall
#

execute "open firewall port" do
  timeout 5
  command "netsh advfirewall firewall add rule name=\"SQL Server\" dir=in action=allow protocol=TCP localport=#{node['sql_server']['port']}"
  not_if "netsh advfirewall firewall show rule name=\"SQL Server\""
end


#
#regedit
#

service 'MSSQLSERVER' do
  action :nothing
end

registry_key node['sql_server']['reg_key_tcp'] do
  values [{ :name => 'Enabled', :type => :dword, :data => 1}]
  notifies :restart, "service[MSSQLSERVER]", :delayed
end

registry_key node['sql_server']['reg_key_ipall'] do
  values [{ :name => 'TcpPort', :type => :string, :data => "#{node['sql_server']['port']}" },
    { :name => 'TcpDynamicPorts', :type => :string, :data => '' }]
  notifies :restart, "service[MSSQLSERVER]", :delayed
end