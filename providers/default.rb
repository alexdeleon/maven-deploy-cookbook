include Chef::Maven

def coordinate(resource)
  {
    :group_id => resource.group_id,
    :artifact_id => resource.artifact_id,
    :version => resource.version,
    :classifier => resource.classifier,
    :packaging => resource.packaging
  }
end

action :create do
  Chef::Log.info "Deploying #{ new_resource.name } from maven"
  repo_url = node[:maven_deploy][:repository]
  username = nil
  password = nil
  if repo_url.is_a?(Hash)
    repo_data = if repo_url.has_key?(:url)
      repo_url
    else
      if latest?(new_resource.version) || snapshot?(new_resource.version)
        repo_url[:snapshot]
      else
        repo_url[:release]
      end
    end
    repo_url = repo_data[:url]
    username = repo_data[:username]
    password = repo_data[:password]
  end

  repo = Repository.new repo_url, username, password

  updated = repo.get_artifact(coordinate(new_resource), 
    new_resource.deploy_to)

  new_resource.updated_by_last_action(updated)

end
