# InSpec test for recipe mongo_cookbook::default

# The InSpec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

unless os.windows?
  # This is an example test, replace with your own test.
  describe user('root'), :skip do
    it { should exist }
  end
end

# This is an example test, replace it with your own test.
describe package 'mongodb-org' do
  it { should be_installed}
  its('version') { should match /3\./ }
end

describe service 'mongod' do
  it { should be_enabled }
  it { should be_running }
end

describe port(27017) do
  it { should be_listening }
end

describe package ('nginx') do
  it { should be_installed }
end
describe service "nginx" do
  it { should be_running }
  it { should be_enabled }
end
describe port(80) do
  it { should be_listening }
end
describe http('http://localhost', enable_remote_worker: true) do
  its('status') { should cmp 502 }
end
