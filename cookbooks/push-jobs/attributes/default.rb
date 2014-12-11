#
# Author:: Joshua Timberman <jtimberman@champagne.int.housepub.org>
# Author:: Charles Johnson <charles@getchef.com>
# Author:: Christopher Maier <cm@getchef.com>
# Copyright 2013-2014 Chef Software, Inc. <legal@getchef.com>
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

default['push_jobs']['gem_url']          = nil
default['push_jobs']['gem_checksum']     = ''

default['push_jobs']['whitelist']   = { 'chef-client' => 'chef-client' }

case node['platform_family']
when 'debian', 'rhel'
  default['push_jobs']['package_url']      = 'http://10.110.42.200/opscode-push-jobs-client-1.1.5-1.el6.x86_64.rpm'
  default['push_jobs']['package_checksum'] = 'f5e6be32f60b689e999dcdceb102371a4ab21e5a1bb6fb69ff4b2243a7185d84'
  default['push_jobs']['service_string'] = 'runit_service[opscode-push-jobs-client]'
when 'windows'
  default['push_jobs']['package_url']      = 'http://10.110.42.200/opscode-push-jobs-client-1.1.5-1.el6.x86_64.rpm'
  default['push_jobs']['package_checksum'] = '411520e6a2e3038cd018ffacee0e76e37e7badd1aa84de03f5469c19e8d6c576'
  default['push_jobs']['service_string'] = 'service[pushy-client]'
end
