sed -i '/riak_core,/a {default_bucket_props, [{allow_mult, true}]},' /etc/riak/app.config
sed -i -f backend.sed /etc/riak/app.config
sed -i 's/127.0.0.1/0.0.0.0/' /etc/riak/app.config
sed -i 's/127.0.0.1/0.0.0.0/' /etc/riak-cs/app.config 
sed -i 's/127.0.0.1/0.0.0.0/' /etc/stanchion/app.config
