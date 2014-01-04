require 'aws/s3'
AWS::S3::Base.establish_connection!(
        :server            => 'localhost',
#        :use_ssl           => false, 
	:port		=> 8080,
        :access_key_id     => 'Z0AYOHZWE1RTBCGTTWG0',
        :secret_access_key => 'h2GTENumkwSvhw29zKamdnTzPdkWyRQkzmL3hA=='
)
#Admin Key: BFNTPUDXWS39AF1RXM50
#Admin Secret: HknoexUOKlQLJrJ924RY-pK_LwCKKG5ZQPJj-Q==
#Admin Key: 0J6EA80T7JV7-4OR_VXQ
#Admin Secret: ouM5qM0ISCWMKe5HU39s18Z8VsjU7ZlwWYnzGQ==
#Admin Key: J7Y0MPUV2VHYETNHCY2D
#Admin Secret: fxTg2frUgcFNv0Dlt4OssRMtKnFFKos_tuoOyQ==

(1..1000).each  do |i|
AWS::S3::S3Object.store(
        "hello#{i}.txt",
        'Hello World!',
        'my-new-bucket3',
        :content_type => 'text/plain'
)
AWS::S3::S3Object.store(
        "hello#{i}.txt",
        'Hello World!',
        'my-new-bucket',
        :content_type => 'text/plain'
)

puts AWS::S3::S3Object.url_for(
        "hello#{i}.txt",
        'my-new-bucket',
        :expires_in => 60 * 60
)
end
