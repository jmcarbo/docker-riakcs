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

ADD backend.json /backend.json
ADD backend.sed /backend.sed
ADD conditioning.sh /conditioning.sh
RUN sh /conditioning.sh
ADD start.sh /start.sh

EXPOSE 22
EXPOSE 8000
EXPOSE 8080

CMD ["/bin/bash", "/start.sh"]
