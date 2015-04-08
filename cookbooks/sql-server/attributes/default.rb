#
# Cookbook Name:: sql-server
# Recipe:: attributes/default.rb
#

default['sql_server']['hostname'] = node['hostname']
default['sql_server']['user'] = "administrator"
default['sql_server']['password'] = ""
default['sql_server']['sa-password'] = ""

default['sql_server']['port'] = "1433"
default['sql_server']['package_name'] = "Microsoft SQL Server 2012  Express Edition"
default['sql_server']['url'] = "https://chefrepo.cloud-platform.kddi.ne.jp/packages/chef/packages/SQLEXPR_x64_JPN.exe"
#default['sql_server']['url'] = "c:\SQLEXPR_x64_JPN.exe"
default['sql_server']['checksum'] = "c417c55fda4f4b7033646f4c899729fd1b25f2650b0980431d0f0b6ad77e806b"
default['sql_server']['installer_timeout'] = 1500

default['sql_server']['reg_key_tcp'] = "HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Microsoft SQL Server\\MSSQL11.MSSQLSERVER\\MSSQLServer\\SuperSocketNetLib\\Tcp"
default['sql_server']['reg_key_ipall'] = "HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Microsoft SQL Server\\MSSQL11.MSSQLSERVER\\MSSQLServer\\SuperSocketNetLib\\Tcp\\IPAll"

