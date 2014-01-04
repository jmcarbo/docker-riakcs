require 'fog'
require 'unf'

client = Fog::RiakCS::Provisioning.new(
  :riakcs_access_key_id     => "Z0AYOHZWE1RTBCGTTWG0",
  :riakcs_secret_access_key => "h2GTENumkwSvhw29zKamdnTzPdkWyRQkzmL3hA==",
  :host                     => '127.0.0.1',
  :port                     => 8080
)

response = client.create_user('pepe@pepe.com', 'pepe')
