# frozen_string_literal: true

def daemontools_bin_dir
  file('/tmp/daemontools-bin-dir').content.strip
end

def daemontools_service_dir
  file('/tmp/daemontools-service-dir').content.strip
end

def daemontools_svscan_service_name
  file('/tmp/daemontools-svscan-service-name').content.strip
end
