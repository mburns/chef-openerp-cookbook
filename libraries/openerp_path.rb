module OpenERP
  module PathHelper
    def openerp_path
      node['openerp']['homedir']
    end

    def openerp_server_path
      "#{node['openerp']['homedir']}/server"
    end

    def openerp_addons_path
      if openerp_short_version < 6.1
        "#{openerp_server_path}/bin/addons"
      else
        "#{openerp_server_path}/openerp/addons"
      end
    end
  end
end

::Chef::Recipe.send(:include, ::OpenERP::PathHelper)
::Chef::Resource::RemoteFile.send(:include, ::OpenERP::PathHelper)
::Chef::Resource::Bash.send(:include, ::OpenERP::PathHelper)
::Chef::Resource::Template.send(:include, ::OpenERP::PathHelper)
