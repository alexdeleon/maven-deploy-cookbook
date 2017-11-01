
package 'httpd'

service 'httpd' do
  action :start
end

repo_path = '/var/www/html/maven2/junit/junit'
xml_path = "#{repo_path}/maven-metadata.xml"
jar_path = "#{repo_path}/4.12/junit-4.12.jar"
md5_path = "#{repo_path}/4.12/junit-4.12.jar.md5"

[::File.dirname(repo_path), ::File.dirname(xml_path), ::File.dirname(md5_path)].each do |fake_dir|
  directory fake_dir do
    recursive true
  end
end

file xml_path do
  content '''<metadata>
<groupId>junit</groupId>
<artifactId>junit</artifactId>
<versioning>
<latest>4.12</latest>
<release>4.12</release>
<versions>
<version>4.12</version>
</versions>
<lastUpdated>20141204181041</lastUpdated>
</versioning>
</metadata>'''
end

file jar_path do
  content 'fake jar file'
end

file md5_path do
  content '40c264dbe8b95866613f39e5798cf4e1'
end
