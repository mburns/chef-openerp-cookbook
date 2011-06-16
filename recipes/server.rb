#
# Cookbook Name:: openerp
# Recipe:: default
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

#e = execute "apt-get update" do
#  action :nothing
#end
#e.run_action(:run)

# Packages needed for the core OpenERP Server
%w{ python python-setuptools python-lxml python-mako python-egenix-mxdatetime python-dateutil
    python-psycopg2 python-pychart python-pydot python-tz python-reportlab python-yaml
    python-vobject }.each do |pkg|
  package pkg do
    action :install
  end
end

user "openerp" do
  comment "OpenERP System User"
  system true
  shell "/bin/false"
  home "/opt/openerp"
  manage_home true
end

remote_file "openerp-server" do
  path "#{Chef::Config['file_cache_path']}/openerp-server.tar.gz"
  source "http://www.openerp.com/download/stable/source/openerp-server-#{node[:openerp][:version]}.tar.gz"
  mode "0644"
end

bash "untar-openerp-server" do
  code <<-EOH
  tar zxvf #{Chef::Config['file_cache_path']}/openerp-server.tar.gz -C /opt/openerp
  chown -R openerp: /opt/openerp/openerp-server-#{node[:openerp][:version]}
  EOH
  not_if do File.exist?("/opt/openerp/openerp-server-#{node[:openerp][:version]}") &&
    File.directory?("/opt/openerp/openerp-server-#{node[:openerp][:version]}")
  end
end

link "/opt/openerp/openerp-server" do
  to "openerp-server-#{node[:openerp][:version]}"
end