require 'fog'
require 'unf'

connection = Fog::Storage.new({
  :provider                 => 'AWS',
  :aws_access_key_id     => "Z0AYOHZWE1RTBCGTTWG0",
  :aws_secret_access_key => "h2GTENumkwSvhw29zKamdnTzPdkWyRQkzmL3hA==",
  :host                     => '192.168.1.4',
  :port                     => 8080,
  :scheme => 'http',
  :connection_options => {
    :proxy => 'http://192.168.1.4:8080',
  }
})

#response = client.create_user('pepe@pepe.com', 'pepe')
#users = client.list_users(:status => 'enabled')
directory = connection.directories.create(
  :key    => "fog-demo-#{Time.now.to_i}", # globally unique name
  :public => true
)

file = directory.files.create(
  :key    => 'resume.html',
  :body   => ' asdfasdfas sadfas dfas df sadfas dfas df as dfasf d',
  :public => true
)
