include Chef::Maven

def coordinate(resource)
  {
    :group_id => resource.group_id,
    :artifact_id => resource.artifact_id,
    :version => resource.version,
    :classifier => resource.classifier,
    :packaging => resource.packaging,
    :useMavenMetadata => resource.useMavenMetadata
  }
end

action :create do

  repositories = node[:maven_deploy][:repositories]
  ok = false

  repositories.each do | key, repository |
    ok = deploy(coordinate(new_resource), repository, new_resource.deploy_to)
    break if ok
  end

  if not ok then
    raise "Not found artifact #{ new_resource.name } in any of the provided repositories"
  end
end

# Returns true if artifact was correctly downloaded from repository
def deploy(coordinates, repository, deploy_to)
  username = nil, password = nil
  repo_url = if repository.is_a?(Hash)
    repo_data = if repository.has_key?(:url)
      repository
    else
      if latest?(coordinates[:version]) || snapshot?(coordinates[:version])
        repository[:snapshots]
      else
        repository[:releases]
      end
    end
    if repo_data.nil?
      return false
    end
    username = repo_data[:username]
    password = repo_data[:password]
    repo_data[:url]
  else
    repository
  end

  begin

    Chef::Log.info "Trying to deploy #{ new_resource.name } from #{ repo_url }"

    repo = Repository.new repo_url, username, password

    if not repo.artifact_updated?(coordinates, deploy_to)
      if repo.get_artifact(coordinates, deploy_to)
        new_resource.updated_by_last_action(true)
        if new_resource.validate_checksum
          if not repo.artifact_updated?(coordinates, deploy_to)
            Chef::Log.error 'Checksum error!!'
            raise Exception('Checksum error!!!')
          end
        end
      end
    end


    rescue Exception => e
      Chef::Log.info "Error when trying to deploy #{ new_resource.name } from #{ repo_url }: #{e.message}"
      return false
  end
  return true
end
