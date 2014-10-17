# KCPS2
# default['chef-server']['repo1']['fqdn'] = 'tck2ejo2-chfrp01.tck2vm.local'
# default['chef-server']['repo1']['ipaddr'] = '10.189.0.13'
# default['chef-server']['repo2']['fqdn'] = ''
# default['chef-server']['repo2']['ipaddr'] = ''
# default['chef-server']['ap1']['fqdn'] = 'tck2ejo2-chfap01.tck2vm.local'
# default['chef-server']['ap1']['ipaddr'] = '10.189.0.7'
# default['chef-server']['ap2']['fqdn'] = ''
# default['chef-server']['ap2']['ipaddr'] = ''
# default['chef-server']['db1']['fqdn'] = 'tck2ejo2-chfdb01.tck2vm.local'
# default['chef-server']['db1']['ipaddr'] = '10.189.0.8'
# default['chef-server']['db2']['fqdn'] = ''
# default['chef-server']['db2']['ipaddr'] = ''
#
# default['chef-server']['db_vip']['fqdn'] = 'tck2ejo2-chfdb01.tck2vm.local'
# default['chef-server']['db_vip']['ipaddr'] = '10.189.0.8'
# default['chef-server']['api']['fqdn'] = 'tck2ejo2-chfap01.tck2vm.local'
#
# default['chef-server']['lvm_physical_volume'] = '/dev/mapper/vgBoot02-LogVol00'

# SL
default['chef-server']['repo1']['fqdn'] = 'repo.urasoko.com'
default['chef-server']['repo1']['ipaddr'] = '10.110.42.200'
default['chef-server']['repo2']['fqdn'] = ''
default['chef-server']['repo2']['ipaddr'] = ''
default['chef-server']['ap1']['fqdn'] = 'ap01.urasoko.com'
default['chef-server']['ap1']['ipaddr'] = '10.110.42.201'
default['chef-server']['ap2']['fqdn'] = ''
default['chef-server']['ap2']['ipaddr'] = ''
default['chef-server']['db1']['fqdn'] = 'db01.urasoko.com'
default['chef-server']['db1']['ipaddr'] = '10.110.42.205'
default['chef-server']['db2']['fqdn'] = ''
default['chef-server']['db2']['ipaddr'] = ''

default['chef-server']['db_vip']['fqdn'] = 'db01.urasoko.com'
default['chef-server']['db_vip']['ipaddr'] = '10.110.42.205'
default['chef-server']['api']['fqdn'] = 'ap01.urasoko.com'

default['chef-server']['lvm_physical_volume'] = '/dev/xvdc'


default['chef-server']['core']['package'] = 'chef-server-core-12.0.0_rc.4-1.el5.x86_64.rpm'
default['chef-server']['core']['checksum'] = '119be4c0dad1128dbc46e6bdacf72711c8e29d346ad4f842a3b734e346eb18ae'
default['chef-server']['manage']['package'] = 'opscode-manage-1.6.2-1.el6.x86_64.rpm'
default['chef-server']['manage']['checksum'] = '59100815a5e86f2a9de6beb03605d1b90e93f5ef0eecf336222f46a7e29f340b'
default['chef-server']['push']['package'] = 'opscode-push-jobs-server-1.1.3-1.el6.x86_64.rpm'
default['chef-server']['push']['checksum'] = '8234d84f06437a09890fa7184f16429cb4ff862913e60d434d48a1d865aea70c'
default['chef-server']['sync']['package'] = 'chef-sync-1.0.0_rc.3-1.x86_64.rpm'
default['chef-server']['sync']['checksum'] = '8c91c247ce07da02f56a05687dee69038deab4ba1637e8b9d10bbf83c1b0306d'
default['chef-server']['report']['package'] = 'opscode-reporting-1.1.6-1.x86_64.rpm'
default['chef-server']['report']['checksum'] = 'b9cf2bd2ea16f092a43f4abc8b5dbb6461761e9fb197ae20d09168cfd220bd10'

default['chef-server']['install_path'] = '/tmp'

default['chef-server']['topology'] = 'tier'

default['chef-server']['open4']['gem'] = 'open4-1.3.4.gem'
default['chef-server']['lvm']['gem'] = 'di-ruby-lvm-0.1.3.gem'
default['chef-server']['lvm_attr']['gem'] = 'di-ruby-lvm-attrib-0.0.14.gem'

default['chef-server']['drbd84-utils']['package'] = 'drbd84-utils-8.9.1-1.el6.elrepo.x86_64.rpm'
default['chef-server']['drbd84-utils']['checksum'] = '8cf2189f31ca619ddef8cc4f7faf49e5b99793abba35378189b5fbba1b71b3d3'
default['chef-server']['kmod-drbd84']['package'] = 'kmod-drbd84-8.4.5-1.el6.elrepo.x86_64.rpm'
default['chef-server']['kmod-drbd84']['checksum'] = 'dad4fa0710f5f3d385606495bfdfea98b41b2f6530894d2109c62a3d3fa0a04c'
