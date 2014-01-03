docker-riakcs
=============

RiakCS docker container

First and foremost, the host computer must have proper ulimits (change following files):

* /etc/security/limits.conf

```
  soft     nofile          65536
  hard     nofile          65536
```

* /etc/pam.d/common-session

```
session    required   pam_limits.so
```

* /etc/pam.d/common-session-noninteractive

```
session    required   pam_limits.so
```

* /etc/default/docker

```
ulimit -n 10000
```

# Build with

```
docker build -t jmca/riakcs github.com/jmcarbo/docker-riakcs
```

# References

* http://docs.basho.com/riakcs/latest/tutorials/fast-track/Building-a-Local-Test-Environment/
