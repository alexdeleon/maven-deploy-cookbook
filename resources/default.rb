actions :create, :delete
default_action :create

attribute :name, :name_attribute => true, :kind_of => String,
            :required => true

attribute :deploy_to, :kind_of => String, :required => true
attribute :artifact_id, :kind_of => String, :required => true
attribute :group_id, :kind_of => String, :required => true
attribute :version, :kind_of => String, :required => true
attribute :classifier, :kind_of => String
attribute :packaging, :kind_of => String, :default => 'jar'
attribute :useMavenMetadata, :kind_of => [TrueClass, FalseClass], :default => true

attr_accessor :exists
