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
  end
end
