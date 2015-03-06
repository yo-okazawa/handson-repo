#
# Cookbook Name:: runit
# Recipe:: default
#
# Copyright 2008-2010, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the 'License');
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an 'AS IS' BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
case node['platform_family']
when 'rhel'
  remote_file '/tmp/runit-2.1.1.rpm' do
    source 'https://chefrepo.cloud-platform.kddi.ne.jp/packages/chef/packages/runit-2.1.1.rpm'
    checksum '622351a75345b6bd302bc1b99771df98fe26da22862c588cd745c33876df903d'
  end

  rpm_package 'runit' do
    source '/tmp/runit-2.1.1.rpm'
  end
end
