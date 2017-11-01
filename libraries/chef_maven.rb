require 'net/http'
require 'rexml/document'

class Chef

  module Maven

    def snapshot?(version)
        version.end_with? '-SNAPSHOT'
    end

    def latest?(version)
        version.upcase == 'LATEST'
    end

    class Repository

      include Chef::Maven

    	def initialize(repo_url, username = nil, password = nil)
        	@repo_url = repo_url
        	@username = username
        	@password = password
    	end

      def artifact_updated?(coordinates, dest)
        if  File.exist?(dest)
          file_md5 = Digest::MD5.file(dest).hexdigest
          md5 = get_artifact_md5(coordinates)
          if(file_md5 === md5)
            return true
          end
        end
        return false
    	end

    	def get_artifact(coordinates, dest)
        return get build_uri(coordinates), dest
    	end

    	def get_actual_version(coordinates)
    		if latest?(coordinates[:version])
          latestElement = REXML::Document.new(get_artifact_info(coordinates)).elements["//latest"]
          version = if latestElement
            latestElement.text
          else
            REXML::Document.new(get_artifact_info(coordinates)).elements["//version[last()]"].text
          end
          coordinates[:version] = version
        end
    	end

        def get_build_file_name(coordinates)
          # attempt to deploy a snapshot submodule
          ret = nil
          xml = REXML::Document.new(get_version_info(coordinates))
          node = xml.elements["//extension[text()='#{coordinates[:packaging]}']/../value"]

          # attempt to deploy a primary snapshot module
          if node.nil?
            timestamp = xml.elements['/metadata/versioning/snapshot/timestamp']
            build_number = xml.elements['/metadata/versioning/snapshot/buildNumber']

            unless timestamp.nil? || build_number.nil?
                ret = "#{coordinates[:version].slice(0, coordinates[:version].rindex('-SNAPSHOT'))}-#{timestamp.text}-#{build_number.text}"
            end
          else
              ret = node.text
          end

          Chef::Log.debug("Build file name is #{ret}")
          ret
        end

    	def get_build(coordinates)
        if(coordinates[:useMavenMetadata])
          get_actual_version(coordinates)
      		coordinates[:build] = if snapshot?(coordinates[:version])
                  get_build_file_name(coordinates)
      		else
      			coordinates[:version]
      		end
        else
          coordinates[:build] = coordinates[:version]
        end
    	end

    	def get_artifact_info(coordinates)
    		uri = build_uri(coordinates, :artifact_info)
    		get(uri)
    	end

    	def get_version_info(coordinates)
    		uri = build_uri(coordinates, :version_info)
    		get(uri)
    	end

      def get_artifact_md5(coordinates)
        uri = build_uri(coordinates, :md5)
        get(uri)
      end

      private  # ------------ Helper methods ------------ #

      def build_uri(coordinates, type = :artifact)
        case type
        when :artifact_info
          URI("#{@repo_url}/#{coordinates[:group_id].tr('\.','/')}/#{coordinates[:artifact_id]}/maven-metadata.xml")
        when :version_info
          URI("#{@repo_url}/#{coordinates[:group_id].tr('\.','/')}/#{coordinates[:artifact_id]}/#{coordinates[:version]}/maven-metadata.xml")
        when :md5
          get_build(coordinates) unless coordinates.has_key?(:build)
          URI("#{@repo_url}/#{coordinates[:group_id].tr('\.','/')}/#{coordinates[:artifact_id]}/#{coordinates[:version]}/#{coordinates[:artifact_id]}#{coordinates[:build] ? '-'+coordinates[:build] : ''}#{coordinates[:classifier] ? '-'+coordinates[:classifier] : ''}.#{coordinates[:packaging]}.md5")
        when :artifact
          get_build(coordinates) unless coordinates.has_key?(:build)
          URI("#{@repo_url}/#{coordinates[:group_id].tr('\.','/')}/#{coordinates[:artifact_id]}/#{coordinates[:version]}/#{coordinates[:artifact_id]}#{coordinates[:build] ? '-'+coordinates[:build] : ''}#{coordinates[:classifier] ? '-'+coordinates[:classifier] : ''}.#{coordinates[:packaging]}")
        end
      end

      def get(uri, dest = nil)

        artifact_downloaded = false

        Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|

          request = Net::HTTP::Get.new uri.request_uri
          request.basic_auth @username, @password if @username && @password

          http.request request do |response|

             # Exception launched to continue searching in the next repository
            raise unless response.is_a?(Net::HTTPSuccess)

            if dest
              begin
                file = open(dest, "wb")
                response.read_body do |segment|
                  file.write(segment)
                end
                artifact_downloaded = true
              rescue Exception => e
                Chef::Log.info "Failed to download from #{uri}: #{e}"
              ensure
                file.close unless file.nil?
              end
            else
              return response.body
            end
          end
          artifact_downloaded
        end
      end
    end
  end
end
