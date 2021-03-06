#
# Cookbook Name:: openerp
# Recipe:: common
#
# Copyright 2011, Atriso BVBA
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

###
# Resources common to the core OpenERP server and webclient
###

# Common packages
# Packages needed for the core OpenERP Server
%w(python python-setuptools).each do |pkg|
  package pkg do
    action :install
  end
end

# Common user
user node['openerp']['user'] do
  comment 'OpenERP System User'
  system true
  shell '/bin/false'
  home node['openerp']['homedir']
  manage_home true
end

# Common paths
directory '/var/log/openerp' do
  owner node['openerp']['user']
  group 'root'
end
