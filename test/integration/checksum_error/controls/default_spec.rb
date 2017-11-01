# frozen_string_literal: true

title 'maven_deploy inspec'

control 'default-001' do
  impact 1.0
  title 'The artifact is deployed'
  desc 'The artifact is deployed in /tmp/'

  # Inspec examples can be found at
  # http://inspec.io
  describe file('/tmp/junit.jar') do
    it { should exist }
    its('content') { should match /^fake jar file$/ }
  end

  describe file('/var/log/httpd/access_log') do
    it { should exist }
    its('content') { should match '/maven2/junit/junit/maven-metadata.xml HTTP/1.1" 200' }
    its('content') { should match '/maven2/junit/junit/4.12/junit-4.12.jar HTTP/1.1" 200' }
    its('content') { should match '/maven2/junit/junit/4.12/junit-4.12.jar.md5 HTTP/1.1" 200' }
  end
end
