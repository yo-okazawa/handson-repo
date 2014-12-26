include_recipe "chef-server::drbd"

execute "chef-server-ctl reconfigure"

include_recipe "chef-server::post"
