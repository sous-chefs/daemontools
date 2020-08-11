name             'daemontools'
maintainer       'Joshua Timberman'
maintainer_email 'cookbooks@housepub.org'
license          'Apache-2.0'
description      'Installs/Configures daemontools'
version          '1.5.0'

depends 'pacman', '~> 1.2'

%w(debian ubuntu arch redhat centos gentoo).each do |os|
  supports os
end
