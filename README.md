# maven_deploy cookbook
Deploys artifacts from standard maven repositories

## Supported Platforms
All Platforms

## Attributes
There are different configurations according to the defined attributes:

### Basic configuration
|Key|Description|Type|Default|
|:-:|:--:|:---------:|:-----:|
|['maven_deploy']['repositories']['repository']|The url of maven repository|String| * |

### Repository with auth configuration
|Key|Description|Type|Default|
|:-:|:--:|:---------:|:-----:|
|['maven_deploy']['repositories']['repository'][url]|The url of maven repository|String| * |
|['maven_deploy']['repositories']['repository'][username]|The username for authenticating with your maven repository|String| * |
|['maven_deploy']['repositories']['repository'][password]|The password for authenticating with your maven repository|String| * |

### Release repository configuration
|Key|Description|Type|Default|
|:-:|:--:|:---------:|:-----:|
|['maven_deploy']['repositories']['repository'][release][url]|The url of maven release repository|String| * |
|['maven_deploy']['repositories']['repository'][release][username]|The username for authenticating with your maven release repository|String| * |
|['maven_deploy']['repositories']['repository'][release][password]|The password for authenticating with your maven release repository|String| * |

### Snapshot repository configuration
|Key|Description|Type|Default|
|:-:|:--:|:---------:|:-----:|
|['maven_deploy']['repositories']['repository'][snapshot][url]|The url of maven snapshot repository|String| * |
|['maven_deploy']['repositories']['repository'][snapshot][username]|The username for authenticating with your maven snapshot repository|String| * |
|['maven_deploy']['repositories']['repository'][snapshot][password]|The password for authenticating with your maven snapshot repository|String| * |

## Usage
In your recipe:

```ruby
maven_deploy "junit" do
  group_id "junit"
  artifact_id "junit"
  deploy_to "/tmp/junit.jar"
  version "latest"
end
```

## Contributing
1. Fork the repository on Github
2. Create a named feature branch (i.e. `add-new-recipe`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request

## License and Authors

Author:: Alexander De Leon (@alexjdl)
