# Encoding: UTF-8

name 'divvy'
maintainer 'Jonathan Hartman'
maintainer_email 'j@p4nt5.com'
license 'apache2'
description 'Installs/Configures Divvy'
long_description 'Installs/Configures Divvy'
version '0.2.2'

source_url 'https://github.com/roboticcheese/divvy-chef'
issues_url 'https://github.com/roboticcheese/divvy-chef/issues'

depends 'mac-app-store', '~> 2.0'
depends 'privacy_services_manager', '~> 1.0'
depends 'windows', '~> 1.36'

supports 'mac_os_x'
supports 'windows'
