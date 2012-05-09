module OpenERP
  module NameHelper
    def openerp_server_tarball_url
      if openerp_short_version < 6.1
        "http://www.openerp.com/download/stable/source/#{openerp_server_tarball}"
      else
        "http://nightly.openerp.com/#{openerp_short_version}/releases/#{openerp_server_tarball}"
      end
    end

    def openerp_unix_name
      if openerp_short_version <= 6.0
        "openerp-server"
      else
        # From 6.1 on the webclient is integrated in the server, and the
        # server package is renamed to just "openerp"
        "openerp"
      end
    end

    def openerp_server_tarball
      "#{openerp_unix_name}-#{openerp_version}.tar.gz"
    end

    def openerp_version
      node[:openerp][:version]
    end

    # '6.1-1', '6.1rc1' => 6.1
    def openerp_short_version
      openerp_version[/\d+\.\d+/].to_f
    end
  end
end

[::Chef::Recipe, 
 ::Chef::Resource::RemoteFile,
 ::Chef::Resource::Bash,
 ::Chef::Resource::Template,
 ::Chef::Resource::Link
].each {|mod| mod.send(:include, ::OpenERP::NameHelper) }

