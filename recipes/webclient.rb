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

# From 6.1 on the webclient is integrated in the server, but needs some extra
# dependencies
if openerp_short_version >= 6.1

  %w(python-werkzeug python-babel python-openid).each do |pkg|
    package(pkg) { action :install }
  end

else

  # Packages needed for the OpenERP Web Client
  %w{ build-essential python-beaker python-cherrypy3 python-formencode python-pybabel }.each do |pkg|
    package pkg do
      action :install
    end
  end
  
  remote_file "#{Chef::Config['file_cache_path']}/openerp-web-#{node[:openerp][:version]}.tar.gz" do
    action :create_if_missing
    source "http://www.openerp.com/download/stable/source/openerp-web-#{node[:openerp][:version]}.tar.gz"
    mode "0644"
  end

  bash "untar-openerp-server" do
    code <<-EOH
  tar zxvf #{Chef::Config['file_cache_path']}/openerp-web-#{node[:openerp][:version]}.tar.gz -C #{openerp_path}
  chown -R openerp: #{openerp_path}/openerp-web-#{node[:openerp][:version]}
  EOH
    not_if do File.exist?("#{openerp_path}/openerp-web-#{node[:openerp][:version]}") &&
        File.directory?("#{openerp_path}/openerp-web-#{node[:openerp][:version]}")
    end
  end
  
  link "#{openerp_path}/web" do
    to "openerp-web-#{openerp_version}"
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

end
