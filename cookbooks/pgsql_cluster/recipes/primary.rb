#
# Cookbook Name:: pgsql_cluster
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

include_recipe "pgsql_cluster::drbd_common"
include_recipe "pgsql_cluster::drbd_primary"

include_recipe "pgsql_cluster::pgsql_common"
include_recipe "pgsql_cluster::pgsql_primary"

include_recipe "pgsql_cluster::pacemaker_common"
include_recipe "pgsql_cluster::pacemaker_primary"
