FROM ruby:2.4.4

ADD bin /root/bin
ADD lib /root/lib

ENTRYPOINT ["/root/bin/pokereval"]
