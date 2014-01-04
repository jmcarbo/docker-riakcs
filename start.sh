#!/bin/bash
# initialize admin user
if [ ! -d "/var/lib/riak/leveldb" ]; then
	perl -pi -e 's/{anonymous_user_creation, false}/{anonymous_user_creation, true}/g' /etc/riak-cs/app.config
        mkdir -p /var/lib/riak/ring
        chown -R riak:riak /var/lib/riak        
	riak start 
	sleep 4
	stanchion start 
	sleep 4
	riak-cs start
	sleep 5
	curl -sS -H 'Content-Type: application/json' -X POST http://localhost:8080/riak-cs/user --data '{"email":"jmcarbo@gmail.com", "name":"admin user"}' > /var/lib/riak/admin_user.json
	KEY=`cat /var/lib/riak/admin_user.json | grep -E -o '"key_id":"[^\"]+"' | sed -e 's/\"//g' | cut -d : -f 2`
	SECRET=`cat /var/lib/riak/admin_user.json | grep -E -o '"key_secret":"[^\"]+"' | sed -e 's/\"//g' | cut -d : -f 2`

	riak-cs stop
	stanchion stop
	riak stop

	sleep 3

#       perl -pi -e 's/###KEY###/'$KEY'/g' /etc/riak/app.config
#       perl -pi -e 's/###SECRET###/'$SECRET'/g' /etc/riak/app.config

	perl -pi -e 's/{anonymous_user_creation, true}/{anonymous_user_creation, false}/g' /etc/riak-cs/app.config
fi

KEY=`cat /var/lib/riak/admin_user.json | grep -E -o '"key_id":"[^\"]+"' | sed -e 's/\"//g' | cut -d : -f 2`
SECRET=`cat /var/lib/riak/admin_user.json | grep -E -o '"key_secret":"[^\"]+"' | sed -e 's/\"//g' | cut -d : -f 2`

sed -i  "/admin_key/c\{admin_key, \"$KEY\"}," /etc/riak-cs/app.config
sed -i  "/admin_secret/c\{admin_secret, \"$SECRET\"}," /etc/riak-cs/app.config

sed -i  "/admin_key/c\{cs_admin_key, \"$KEY\"}," /etc/riak-cs-control/app.config
sed -i  "/admin_secret/c\{cs_admin_secret, \"$SECRET\"}," /etc/riak-cs-control/app.config

sed -i  "/admin_key/c\{admin_key, \"$KEY\"}," /etc/stanchion/app.config
sed -i  "/admin_secret/c\{admin_secret, \"$SECRET\"}" /etc/stanchion/app.config

riak start
sleep 2
stanchion start
riak-cs start
riak-cs-control start


# start SSH
/usr/sbin/sshd


echo "Admin Key: "$KEY
echo "Admin Secret: "$SECRET

# keep script in foreground
while(true) do
    sleep 60
done
