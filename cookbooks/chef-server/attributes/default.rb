default['chef-server']['repo1']['fqdn'] = 'tck2ejo2-chfrp01.tck2vm.local'
default['chef-server']['repo1']['ipaddr'] = '10.189.0.13'
default['chef-server']['repo2']['fqdn'] = 'tck2ejo2-chfrp02.tck2vm.local'
default['chef-server']['repo2']['ipaddr'] = '10.189.0.23'
default['chef-server']['repo']['fqdn'] = 'tck2ejo2-chfrp.tck2vm.local'
default['chef-server']['repo']['ipaddr'] = '106.162.226.22'
default['chef-server']['ap1']['fqdn'] = 'tck2ejo2-chfap01.tck2vm.local'
default['chef-server']['ap1']['ipaddr'] = '10.189.0.7'
default['chef-server']['ap2']['fqdn'] = 'tck2ejo2-chfap02.tck2vm.local'
default['chef-server']['ap2']['ipaddr'] = '10.189.0.14'
default['chef-server']['db1']['fqdn'] = 'tck2ejo2-chfdb01.tck2vm.local'
default['chef-server']['db1']['ipaddr'] = '10.189.0.8'
default['chef-server']['db2']['fqdn'] = 'tck2ejo2-chfdb02.tck2vm.local'
default['chef-server']['db2']['ipaddr'] = '10.189.0.17'

default['chef-server']['db_vip']['fqdn'] = 'tck2ejo2-chfdb.tck2vm.local'
default['chef-server']['db_vip']['ipaddr'] = '10.189.0.27'
default['chef-server']['db_vip']['device'] = 'eth1'

default['chef-server']['api']['fqdn'] = 'tck2ejo2-chfap.tck2vm.local'
default['chef-server']['api']['ip'] = '106.162.226.23'

default['chef-server']['ws']['fqdn'] = 'tck2ejo2-chfws01.tck2vm.local'
default['chef-server']['ws']['ipaddr'] = '198.18.0.13'

default['chef-server']['lvm_physical_volume'] = '/dev/mapper/vgBoot02-LogVol00'

default['chef-server']['anltcs']['fqdn'] = default['chef-server']['ws']['fqdn']

default['chef-server']['topology'] = 'ha'

default['chef-server']['core']['package'] = 'chef-server-core-12.0.0_rc.5-1.el5.x86_64.rpm'
default['chef-server']['core']['checksum'] = '9980361a764b7ba976924ab93c8935b8d4c2ef326b8c4a612df0061f90041901'
default['chef-server']['manage']['package'] = 'opscode-manage-1.6.2-1.el6.x86_64.rpm'
default['chef-server']['manage']['checksum'] = '59100815a5e86f2a9de6beb03605d1b90e93f5ef0eecf336222f46a7e29f340b'
default['chef-server']['push']['package'] = 'opscode-push-jobs-server-1.1.3-1.el6.x86_64.rpm'
default['chef-server']['push']['checksum'] = '8234d84f06437a09890fa7184f16429cb4ff862913e60d434d48a1d865aea70c'
default['chef-server']['sync']['package'] = 'chef-sync-1.0.0_rc.3-1.x86_64.rpm'
default['chef-server']['sync']['checksum'] = '8c91c247ce07da02f56a05687dee69038deab4ba1637e8b9d10bbf83c1b0306d'
default['chef-server']['report']['package'] = 'opscode-reporting-1.1.7-1.x86_64.rpm'
default['chef-server']['report']['checksum'] = 'f938dde4e61729eb727969e853852991f3437e6baed3e469800108a585663711'
default['chef-server']['anltcs']['package'] = 'opscode-analytics-1.0.4-1.el6.x86_64.rpm'
default['chef-server']['anltcs']['checksum'] = '0b818b0ca878f05059e945dfd0f07d5cd98dfb0e323e42f2e854b71446e29ded'

default['chef-server']['install_path'] = '/tmp'

default['chef-server']['open4']['gem'] = 'open4-1.3.4.gem'
default['chef-server']['lvm']['gem'] = 'di-ruby-lvm-0.1.3.gem'
default['chef-server']['lvm_attr']['gem'] = 'di-ruby-lvm-attrib-0.0.14.gem'

default['chef-server']['drbd84-utils']['package'] = 'drbd84-utils-8.9.1-1.el6.elrepo.x86_64.rpm'
default['chef-server']['drbd84-utils']['checksum'] = '8cf2189f31ca619ddef8cc4f7faf49e5b99793abba35378189b5fbba1b71b3d3'
default['chef-server']['kmod-drbd84']['package'] = 'kmod-drbd84-8.4.5-2.el6.elrepo.x86_64.rpm'
default['chef-server']['kmod-drbd84']['checksum'] = '388e5478c3606ec84e16122c047017ef89f5667c4c18dfdfa5e34f9c7a65d240'
