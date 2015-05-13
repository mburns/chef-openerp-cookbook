# OpenERP Cookbook

[![Build Status](https://travis-ci.org/mburns/chef-openerp-cookbook.svg)](https://travis-ci.org/mburns/chef-openerp-cookbook)

## DESCRIPTION:

Installs and configures OpenERP server (version 6), web-client and database.

## STATUS:

Although the rest of the document indicates that this cookbook can install OpenERP in
a distributed setup, the current version only supports installing everything on the same machine.

This cookbook does not currently support 'Odoo' versions 7 or 8.

## REQUIREMENTS:

### Platform:

Tested on the following platforms:
- Ubuntu 10.04.1.

Tested with the following OpenERP versions:
- 6.0.0

Open for patches to support more systems out of the box! Clone the repo, implement your changes and
submit a pull request. The upstream repo lives here:

https://github.com/atriso/chef-openerp

### Cookbooks:

## ATTRIBUTES: 

* openerp[:version] - Version of openerp to use.

## USAGE:

This cookbook provides a complete OpenERP setup in two ways:

- everything on a single host: database, OpenERP server and web-client installed on a single machine
     and configured correctly to be instantly usable.
- distributed over multiple machines: database, OpenERP server and web-client can be spread
     over multiple machines. The three components will be configured to work together based on the
     results of a Chef search. This requires Chef Server to function correctly.

This cookbook doesn't configure an http proxy against the OpenERP web-client. To prevent too much
assumptions on the specific user setup, it was chosen to not provide that in this cookbook.

### Single-host

The simplest way to install the complete OpenERP stack, including PostgreSQL, is to use the
single-host way. Either include the default OpenERP recipe in your own cookbook, add this
recipe to your node run list or add it to the run list of a role.

include 'openerp'

Without any other options, this will install OpenERP 6.0.0. If you want to install another version,
just override the default version, e.g in a role definition via the Ruby DSL:

override_attributes "openerp" => { "version" => "6.0.1" }

### Distributed

In the distributed setup, you can install every component of the OpenERP stack on a different machine.
The components will be connected to each other based on the result of a Chef search. The search criterium
used will be the node's run list. For example, the OpenERP server will be configured to the database
server using the node information containing the 'openerp::database' recipe in it's run list.

### Installing & Configuring the database server:

include 'openerp::database'

This recipe will relay the PostgreSQL installation to the 'postgresql' cookbook. After the installation
of the PostgreSQL server, the OpenERP database user is created with the proper access rights.

### Server recipe:

include 'openerp::server'

### Web-client recipe:

include 'openerp::webclient'

## LICENSE and AUTHOR:
      
Author:: Michael Burns (michael@mirwin.net)
Author:: Ringo De Smet (<ringo.de.smet@atriso.be>)

Copyright:: 2011, Atriso, BVBA, 2015

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
