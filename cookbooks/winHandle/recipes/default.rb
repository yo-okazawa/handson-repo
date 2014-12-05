#
# Cookbook Name:: winHandle
# Recipe:: default
#


#first test echo
powershell_script "echo Helloworld" do

end

#service iis start
service "IISADMIN" do
  action [ :enable, :start ]
end