require 'spec_helper'

describe file('/tmp/junit.jar') do
	it { should be_file }
end
