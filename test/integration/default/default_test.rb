describe.one do
  describe file(file('/tmp/bin-dir').content + '/svc') do
    it { should exist }
  end

  describe file('/usr/bin/svc') do
    it { should exist }
  end
end

describe processes('svscan') do
  it { should exist }
end
