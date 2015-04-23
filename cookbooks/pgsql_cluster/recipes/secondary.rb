#
# Cookbook Name:: pgsql_cluster
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

include_recipe "pgsql_cluster::drbd_common"
include_recipe "pgsql_cluster::drbd_secondary"

include_recipe "pgsql_cluster::pgsql_common"

include_recipe "pgsql_cluster::pacemaker_common"
