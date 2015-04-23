#
# Cookbook Name:: pgsql_cluster
# Attribute:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

default["pgsql_cluster"]["primary"]["ip"] = "10.110.42.209"
default["pgsql_cluster"]["primary"]["hostname"] = "primary.h-arai.com"

default["pgsql_cluster"]["secondary"]["ip"] = "10.110.42.210"
default["pgsql_cluster"]["secondary"]["hostname"] = "secondary.h-arai.com"

default["pgsql_cluster"]["subnetaddr"] = "10.110.42.192"
default["pgsql_cluster"]["vip"] = "10.110.233.90"
default["pgsql_cluster"]["vip_netmask"] = "30"

default["pgsql_cluster"]["reposerver_url"] = "https://chefrepo.cloud-platform.kddi.ne.jp/packages/chef/packages"
default["pgsql_cluster"]["drbd-utils"] = "drbd84-utils-8.9.1-1.el6.elrepo.x86_64.rpm"
default["pgsql_cluster"]["kmod-drbd"] = "kmod-drbd84-8.4.5-2.el6.elrepo.x86_64.rpm"
default["pgsql_cluster"]["rate"] = "10M"
default["pgsql_cluster"]["disk"] = "/dev/xvdc"
default["pgsql_cluster"]["secret"] = "hogehoge"
default["pgsql_cluster"]["port"] = "7788"
default["pgsql_cluster"]["resource"] = "postgres"
default["pgsql_cluster"]["file_system"] = "ext3"
default["pgsql_cluster"]["device"] = "/dev/drbd0"
default["pgsql_cluster"]["mount_dir"] = "/data"
default["pgsql_cluster"]["res_chenge"] = false

default["pgsql_cluster"]["pgsql_packages"] = ["postgresql-server"]
default["pgsql_cluster"]["pgsql_directory"] = "#{default["pgsql_cluster"]["mount_dir"]}/postgres"

