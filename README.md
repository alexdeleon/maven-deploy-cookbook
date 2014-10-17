# maven_deploy cookbook

Deploys artifacts from standard maven repositories

## Supported Platforms

all

## Attributes

### Basic configuration
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['maven_deploy']['repository']</tt></td>
    <td>String</td>
    <td>The URL of your maven repo</td>
    <td><tt>true</tt></td>
  </tr>
</table>

### Repository with Auth configuration
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['maven_deploy']['respository'][url]</tt></td>
    <td>String</td>
    <td>The URL of your maven repo</td>
    <td><tt>true</tt></td>
  </tr>
  <tr>
    <td><tt>['maven_deploy']['respository'][username]</tt></td>
    <td>String</td>
    <td>The username for authenticating with your maven repo</td>
    <td><tt>true</tt></td>
  </tr>
  <tr>
    <td><tt>['maven_deploy']['respository'][password]</tt></td>
    <td>String</td>
    <td>The username for authenticating with your maven repo</td>
    <td><tt>true</tt></td>
  </tr>
</table>

### Release/Snapshot repository configuration
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['maven_deploy']['respository'][snapshot][url]</tt></td>
    <td>String</td>
    <td>The URL of your maven snaphot repo</td>
    <td><tt>true</tt></td>
  </tr>
  <tr>
    <td><tt>['maven_deploy']['respository'][snapshot][username]</tt></td>
    <td>String</td>
    <td>The username for authenticating with your snapshot maven repo</td>
    <td><tt>true</tt></td>
  </tr>
  <tr>
    <td><tt>['maven_deploy']['respository'][snapshot][password]</tt></td>
    <td>String</td>
    <td>The username for authenticating with your snapshot maven repo</td>
    <td><tt>true</tt></td>
  </tr>
  <tr>
    <td><tt>['maven_deploy']['respository'][snapshot][url]</tt></td>
    <td>String</td>
    <td>The URL of your maven snaphot repo</td>
    <td><tt>true</tt></td>
  </tr>
  <tr>
    <td><tt>['maven_deploy']['respository'][release][username]</tt></td>
    <td>String</td>
    <td>The username for authenticating with your release maven repo</td>
    <td><tt>true</tt></td>
  </tr>
  <tr>
    <td><tt>['maven_deploy']['respository'][snapshot][password]</tt></td>
    <td>String</td>
    <td>The username for authenticating with your release maven repo</td>
    <td><tt>true</tt></td>
  </tr>
</table>


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

Author:: Alexander De Leon (<@alexjdl>)
