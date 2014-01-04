#!/bin/bash

rm -rf /var/lib/riak/*
perl -pi -e 's/{anonymous_user_creation, false}/{anonymous_user_creation, true}/g' /etc/riak-cs/app.config
mkdir -p /var/lib/riak/ring
chown -R riak:riak /var/lib/riak        
riak start 
stanchion start 
riak-cs start
sleep 2
curl -sS -H 'Content-Type: application/json' -X POST http://localhost:8080/riak-cs/user --data '{"email":"jmcarbo@gmail.com", "name":"admin user"}' > /var/lib/riak/admin_user.json
KEY=`cat /var/lib/riak/admin_user.json | grep -E -o '"key_id":"[^\"]+"' | sed -e 's/\"//g' | cut -d : -f 2`
SECRET=`cat /var/lib/riak/admin_user.json | grep -E -o '"key_secret":"[^\"]+"' | sed -e 's/\"//g' | cut -d : -f 2`

riak-cs stop
stanchion stop
riak stop

sed -i  "s/\"admin-key\"/\"$KEY\"/g" /etc/riak-cs/app.config
sed -i  "s/\"admin-secret\"/\"$SECRET\"/g" /etc/riak-cs/app.config

sed -i  "s/\"admin-key\"/\"$KEY\"/g" /etc/riak-cs-control/app.config
sed -i  "s/\"admin-secret\"/\"$SECRET\"/g" /etc/riak-cs-control/app.config

sed -i  "s/\"admin-key\"/\"$KEY\"/g" /etc/stanchion/app.config
sed -i  "s/\"admin-secret\"/\"$SECRET\"/g" /etc/stanchion/app.config

perl -pi -e 's/{anonymous_user_creation, true}/{anonymous_user_creation, false}/g' /etc/riak-cs/app.config


echo "Admin Key: "$KEY
echo "Admin Secret: "$SECRET

