require 'aws/s3'
AWS::S3::Base.establish_connection!(
        :server            => 'localhost',
#        :use_ssl           => false, 
	:port		=> 49189,
        :access_key_id     => 'J7Y0MPUV2VHYETNHCY2D',
        :secret_access_key => 'fxTg2frUgcFNv0Dlt4OssRMtKnFFKos_tuoOyQ=='
)
#Admin Key: BFNTPUDXWS39AF1RXM50
#Admin Secret: HknoexUOKlQLJrJ924RY-pK_LwCKKG5ZQPJj-Q==
#Admin Key: 0J6EA80T7JV7-4OR_VXQ
#Admin Secret: ouM5qM0ISCWMKe5HU39s18Z8VsjU7ZlwWYnzGQ==
#Admin Key: J7Y0MPUV2VHYETNHCY2D
#Admin Secret: fxTg2frUgcFNv0Dlt4OssRMtKnFFKos_tuoOyQ==

AWS::S3::Bucket.create('my-new-bucket')
AWS::S3::Bucket.create('my-new-bucket4')
AWS::S3::Bucket.create('my-new-bucket3')
AWS::S3::Service.buckets.each do |bucket|
        puts "#{bucket.name}\t#{bucket.creation_date}"
end
new_bucket = AWS::S3::Bucket.find('my-new-bucket')
new_bucket.each do |object|
        puts "#{object.key}\t#{object.about['content-length']}\t#{object.about['last-modified']}"
end
#AWS::S3::Bucket.delete('my-new-bucket', :force => true)

AWS::S3::S3Object.store(
        'hello.txt',
        'Hello World!',
        'my-new-bucket3',
        :content_type => 'text/plain'
)
AWS::S3::S3Object.store(
        'hello.txt',
        'Hello World!',
        'my-new-bucket',
        :content_type => 'text/plain'
)

policy = AWS::S3::S3Object.acl('hello.txt', 'my-new-bucket')
policy.grants = [ AWS::S3::ACL::Grant.grant(:public_read) ]
AWS::S3::S3Object.acl('hello.txt', 'my-new-bucket', policy)

#policy = AWS::S3::S3Object.acl('secret_plans.txt', 'my-new-bucket')
#policy.grants = []
#AWS::S3::S3Object.acl('secret_plans.txt', 'my-new-bucket', policy)

#open('/home/larry/documents/poetry.pdf', 'w') do |file|
#        AWS::S3::S3Object.stream('poetry.pdf', 'my-new-bucket') do |chunk|
#                file.write(chunk)
#        end
#end

AWS::S3::S3Object.delete('goodbye.txt', 'my-new-bucket')

puts AWS::S3::S3Object.url_for(
        'hello.txt',
        'my-new-bucket',
        :authenticated => false
)

puts AWS::S3::S3Object.url_for(
        'hello.txt',
        'my-new-bucket',
        :expires_in => 60 * 60
)
