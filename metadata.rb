name              'daemontools'
maintainer        'Sous Chefs'
maintainer_email  'help@sous-chefs.org'
license           'Apache-2.0'
description       'Installs/Configures daemontools'
version           '1.6.2'

depends 'pacman', '~> 1.2'

%w(debian ubuntu arch redhat centos gentoo).each do |os|
  supports os
end

supports 'amazon', '>= 2.0'
