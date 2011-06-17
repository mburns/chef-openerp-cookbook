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

include_recipe "openerp::common"

# Packages needed for the OpenERP Web Client
%w{ build-essential python-beaker python-cherrypy3 python-formencode python-pybabel }.each do |pkg|
  package pkg do
    action :install
  end
end

remote_file "#{Chef::Config['file_cache_path']}/openerp-web-#{node[:openerp][:version]}.tar.gz" do
  source "http://www.openerp.com/download/stable/source/openerp-web-#{node[:openerp][:version]}.tar.gz"
  mode "0644"
end

bash "untar-openerp-server" do
  code <<-EOH
  tar zxvf #{Chef::Config['file_cache_path']}/openerp-web-#{node[:openerp][:version]}.tar.gz -C /opt/openerp
  chown -R openerp: /opt/openerp/openerp-web-#{node[:openerp][:version]}
  EOH
  not_if do File.exist?("/opt/openerp/openerp-web-#{node[:openerp][:version]}") &&
    File.directory?("/opt/openerp/openerp-web-#{node[:openerp][:version]}")
  end
end

link "/opt/openerp/web" do
  to "openerp-web-#{node[:openerp][:version]}"
end

template "/etc/openerp-web.conf" do
  source "openerp-web.conf.erb"
  owner "#{node[:openerp][:user]}"
  group "root"
  mode "0640"
  notifies :restart, "service[openerp-web]", :delayed
end

template "/etc/init.d/openerp-web" do
  source "openerp-web.sh.erb"
  mode "0755"
  notifies :restart, "service[openerp-web]", :delayed
end

service "openerp-web" do
  action :enable
  supports :start => true, :stop => true, :restart => true
end