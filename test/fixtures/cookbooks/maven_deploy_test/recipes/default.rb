
file '/tmp/junit.jar' do
  content 'original file'
end

maven_deploy 'junit' do
  group_id 'junit'
  artifact_id 'junit'
  deploy_to '/tmp/junit.jar'
  version 'latest'
  validate_checksum node['maven_deploy_integration_test']['validate_checksum']
  ignore_failure node['maven_deploy_integration_test']['ignore_failure']
end
