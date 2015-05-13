#
# Cookbook Name:: openerp
# Recipe:: server
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

include_recipe 'openerp::common'

# Packages needed for the core OpenERP Server
%w(python-lxml python-mako python-egenix-mxdatetime python-dateutil
   python-psycopg2 python-pychart python-pydot python-tz python-reportlab python-yaml
   python-vobject).each do |pkg|
  package pkg do
    action :install
  end
end

if openerp_short_version >= 6.1
  %w(python-simplejson python-gdata python-webdav).each do |pkg|
    package pkg do
      action :install
    end
  end
end

remote_file 'openerp-server' do
  action :create_if_missing
  path "#{Chef::Config['file_cache_path']}/#{openerp_server_tarball}"
  source openerp_server_tarball_url
  mode '0644'
end

pkg_dir = "#{openerp_unix_name}-#{openerp_version}"
bash 'untar-openerp-server' do
  code <<-EOH
    tar zxvf #{Chef::Config['file_cache_path']}/#{openerp_server_tarball} -C #{openerp_path}
    chown -R openerp: #{openerp_path}/#{pkg_dir}
  EOH
  not_if { File.exist?("#{openerp_path}/#{pkg_dir}") }
end

link "#{openerp_path}/server" do
  to pkg_dir
end

template '/etc/openerp-server.conf' do
  source 'openerp-server.conf.erb'
  owner node['openerp']['user']
  group 'root'
  mode '0640'
  root_path = "#{openerp_path}/server/#{openerp_short_version < 6.1 ? 'bin' : 'openerp'}"
  variables(
    root_path: root_path,
    addons_path: (["#{root_path}/addons"] + Array(node['openerp']['addons_path'])).flatten.join(',')
  )
  notifies :restart, 'service[openerp-server]', :delayed
end

template '/etc/init.d/openerp-server' do
  source 'openerp-server.sh.erb'
  mode '0755'
  variables daemon: "#{openerp_path}/server/#{openerp_short_version < 6.1 ? 'bin/openerp-server.py' : 'openerp-server'}"
  notifies :restart, 'service[openerp-server]', :delayed
end

service 'openerp-server' do
  action [:enable, :start]
  supports start: true, stop: true, restart: true
end
