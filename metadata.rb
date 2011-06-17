maintainer       "Atriso"
maintainer_email "ringo.de.smet@atriso.be"
license          "Apache 2.0"
description      "Installs and configures OpenERP"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.0.1"
recipe            "openerp", "Shortcut for installing everything the single-host way"
recipe            "openerp::database", "Installs and configures postgresql for OpenERP use"
recipe            "openerp::server", "Installs the core OpenERP server"
recipe            "openerp::webclient", "Installs the OpenERP web client"

%w{ubuntu}.each do |os|
  supports os
end

%w{postgresql openssl}.each do |cb|
  depends cb
end
