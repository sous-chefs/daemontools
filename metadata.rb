name             'daemontools'
maintainer       'Joshua Timberman'
maintainer_email 'cookbooks@housepub.org'
license          'Apache 2.0'
description      'Installs/Configures daemontools'
version          '1.5.0'
recipe 'daemontools', 'Installs daemontools by source or package depending on platform'

%w{ build-essential pacman }.each do |cb|
  depends cb
end

%w{ debian ubuntu arch }.each do |os|
  supports os
end
