describe directory('/opt/enable-oneshot/log') do
  it { should exist }
  its('mode') { should eq 0o755 }
end

describe file('/opt/enable-oneshot/run') do
  it { should exist }
  its('mode') { should eq 0o755 }
end

describe directory(file('/tmp/service-dir').content.strip + '/enable-oneshot') do
  it { should exist }
end

describe directory('/opt/nolog-oneshot/log') do
  it { should_not exist }
end

describe file('/opt/enable-oneshot/log/main/current') do
  it { should exist }
  its('content') { should match /Oneshot\n.*Oneshot/ }
end

describe file('/opt/invoke-oneshot/down') do
  it { should exist }
  its('mode') { should eq 0o644 }
end

describe file('/opt/invoke-oneshot/log/main/current') do
  it { should exist }
  its('content') { should match /Oneshot/ }
  its('content') { should_not match /Oneshot\n.*Oneshot/ }
end

describe directory(file('/tmp/service-dir').content.strip + '/disable-oneshot') do
  it { should_not exist }
end
