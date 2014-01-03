# RiakCS
#
# VERSION               0.0.1

FROM      ubuntu
MAINTAINER Joan Marc Carbo "jmcarbo@gmail.com"

# make sure the package repository is up to date
RUN apt-get update

RUN dpkg-divert --local --rename --add /sbin/initctl
RUN ln -s /bin/true /sbin/initctl
RUN mkdir /var/run/sshd

RUN LC_ALL=C DEBIAN_FRONTEND=noninteractive apt-get -y install vim wget curl sudo lsb-release logrotate libpopt0 cron openssh-server
RUN curl http://apt.basho.com/gpg/basho.apt.key | apt-key add -
RUN bash -c "echo deb http://apt.basho.com $(lsb_release -sc) main > /etc/apt/sources.list.d/basho.list"
RUN apt-get update

RUN LC_ALL=C DEBIAN_FRONTEND=noninteractive apt-get -y install stanchion riak riak-cs riak-cs-control

RUN sed -i '/riak_core,/a {default_bucket_props, [{allow_mult, true}]},' /etc/riak/app.config
ADD backend.json /backend.json
ADD backend.sed /backend.sed
RUN sed -i -f backend.sed /etc/riak/app.config
RUN sed -i 's/127.0.0.1/0.0.0.0/' /etc/riak/app.config
RUN sed -i 's/127.0.0.1/0.0.0.0/' /etc/riak-cs/app.config 
RUN sed -i 's/127.0.0.1/0.0.0.0/' /etc/stanchion/app.config
RUN perl -pi -e 's/{anonymous_user_creation, false}/{anonymous_user_creation, true}/g' /etc/riak-cs/app.config

RUN ulimit -n 5000
RUN echo `ulimit -n`
RUN riak start && stanchion start && stanchion console
RUN sleep 10
RUN riak-cs start

RUN curl -sS -H 'Content-Type: application/json' -X POST http://localhost:8080/riak-cs/user --data '{"email":"jmcarbo@gmail.com", "name":"admin user"}' > /admin_user.json

RUN KEY=`cat /admin_user.json | grep -E -o '"key_id":"[^\"]+"' | sed -e 's/\"//g' | cut -d : -f 2`
RUN SECRET=`cat /admin_user.json | grep -E -o '"key_secret":"[^\"]+"' | sed -e 's/\"//g' | cut -d : -f 2`

RUN echo "Admin Key: "$KEY
RUN echo "Admin Secret: "$SECRET

RUN riak-cs stop
RUN stanchion stop
RUN riak stop

RUN sleep 3

RUN perl -pi -e 's/###KEY###/'$KEY'/g' /etc/riak/app.config
RUN perl -pi -e 's/###SECRET###/'$SECRET'/g' /etc/riak/app.config

RUN perl -pi -e 's/###KEY###/'$KEY'/g' /etc/riak-cs/app.config
RUN perl -pi -e 's/###SECRET###/'$SECRET'/g' /etc/riak-cs/app.config

RUN perl -pi -e 's/###KEY###/'$KEY'/g' /etc/riak-cs-control/app.config
RUN perl -pi -e 's/###SECRET###/'$SECRET'/g' /etc/riak-cs-control/app.config

RUN perl -pi -e 's/###KEY###/'$KEY'/g' /etc/stanchion/app.config
RUN perl -pi -e 's/###SECRET###/'$SECRET'/g' /etc/stanchion/app.config

RUN perl -pi -e 's/{anonymous_user_creation, true}/{anonymous_user_creation, false}/g' /etc/riak-cs/app.config

ADD start.sh /start.sh

EXPOSE 22
EXPOSE 8000
EXPOSE 8080

CMD ["/bin/bash", "/start.sh"]
