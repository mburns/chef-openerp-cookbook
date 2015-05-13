name 'openerp'
maintainer 'mburns'
maintainer_email 'michael@mirwin.net'
license 'Apache 2.0'
description 'Installs and configures OpenERP'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.0.2'
recipe 'openerp', 'Shortcut for installing everything the single-host way'
recipe 'openerp::database', 'Installs and configures postgresql for OpenERP use'
recipe 'openerp::server', 'Installs the core OpenERP server'
recipe 'openerp::webclient', 'Installs the OpenERP web client'
source_url 'https://github.com/mburns/chef-openerp-cookbook' if respond_to?(:source_url)
issues_url 'https://github.com/mburns/chef-openerp-cookbook/issues' if respond_to?(:issues_url)

%w(ubuntu).each do |os|
  supports os
end

%w(postgresql openssl).each do |cb|
  depends cb
end
