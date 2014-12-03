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

    	def get_artifact(coordinates, dest)
    		if  File.exist?(dest)
                file_md5 = Digest::MD5.file(dest).hexdigest
                md5 = get_artifact_md5(coordinates)
                if(file_md5 === md5)
                    return false
                end
            end
            get build_uri(coordinates), dest
            return true
    	end

    	def get_actual_version(coordinates)
    		if latest?(coordinates[:version])
    			version = REXML::Document.new(get_artifact_info(coordinates)).elements["//latest"].text
                unless version
                    version = REXML::Document.new(get_artifact_info(coordinates)).elements["//version[last()]"].text
                end
                coordinates[:version] = version
    		end
    	end

    	def get_build(coordinates)
    		get_actual_version(coordinates)
    		coordinates[:build] = if snapshot?(coordinates[:version])
    			REXML::Document.new(get_version_info(coordinates)).elements["//extension[text()='#{coordinates[:packaging]}']/../value"].text
    		else
    			coordinates[:version]
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

        private  # ------------ helper methods ---- #

    	def build_uri(coordinates, type = :artifact) 
            case type 
    		when :artifact_info 
    			URI("#{@repo_url}/#{coordinates[:group_id].tr('\.','/')}/#{coordinates[:artifact_id]}/maven-metadata.xml")
    		when :version_info
    			URI("#{@repo_url}/#{coordinates[:group_id].tr('\.','/')}/#{coordinates[:artifact_id]}/#{coordinates[:version]}/maven-metadata.xml")
    		when :md5
                get_build(coordinates) unless coordinates.has_key?(:build)
                URI("#{@repo_url}/#{coordinates[:group_id].tr('\.','/')}/#{coordinates[:artifact_id]}/#{coordinates[:version]}/#{coordinates[:artifact_id]}-#{coordinates[:build]}#{coordinates[:classifier] ? '-'+coordinates[:classifier] : ''}.#{coordinates[:packaging]}.md5")
            when :artifact
    			get_build(coordinates) unless coordinates.has_key?(:build)
                URI("#{@repo_url}/#{coordinates[:group_id].tr('\.','/')}/#{coordinates[:artifact_id]}/#{coordinates[:version]}/#{coordinates[:artifact_id]}-#{coordinates[:build]}#{coordinates[:classifier] ? '-'+coordinates[:classifier] : ''}.#{coordinates[:packaging]}")
    		end
    	end

    	def get(uri, dest = nil)
    		puts "Dowloading #{uri}"
	    	Net::HTTP.start(uri.host, uri.port,
			  :use_ssl => uri.scheme == 'https') do |http|

			  request = Net::HTTP::Get.new uri.request_uri
			  request.basic_auth @username, @password if @username && @password

              if dest
                begin
                    file = open(dest, "wb") 
                    http.request request do |response|
                        response.read_body do |segment|
                            file.write(segment)
                        end
                    end
                rescue Exception => e
                    Chef::Log.info "Failed to download from #{uri}: #{e}"
                ensure
                    file.close unless file.nil?
                end                
              else
                response = http.request request
                response.body
              end

			end
		end
    end
  end
end
