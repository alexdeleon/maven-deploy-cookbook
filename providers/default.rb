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
  artifact_updated = false

  repositories.each do | key, repository |
    username = nil, password = nil
    repo_url = if repository.is_a?(Hash)
      repo_data = if repository.has_key?(:url)
        repository
      else
        if latest?(new_resource.version) || snapshot?(new_resource.version)
          repository[:snapshots]
        else
          repository[:releases]
        end
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
      coordinates = coordinate(new_resource)

      if not repo.artifact_updated?(coordinates, new_resource.deploy_to)
        if not repo.get_artifact(coordinates, new_resource.deploy_to)
          next # Cannot get the artifact from current repository, continue with the next repository
        else
          artifact_updated = true
        end
      end

      break # Artifact updated, it's not necessary try with the other repositories

    rescue Exception => e
      Chef::Log.info "Error when trying to deploy #{ new_resource.name } from #{ repo_url }: #{e.message}"
    end
  end
  new_resource.updated_by_last_action(artifact_updated)
end
