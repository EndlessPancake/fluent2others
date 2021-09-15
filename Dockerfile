# AUTOMATICALLY GENERATED
# DO NOT EDIT THIS FILE DIRECTLY, USE /Dockerfile.template.erb

FROM alpine:3.13
LABEL maintainer "Fluentd developers <fluentd@googlegroups.com>"
LABEL Description="Fluentd docker image" Vendor="Fluent Organization" Version="1.13.3"

# Do not split this into multiple RUN!
# Docker creates a layer for every RUN-Statement
# therefore an 'apk delete' has no effect
RUN apk update \
 && apk add --no-cache \
        ca-certificates \
        ruby ruby-irb ruby-etc ruby-webrick \
        tini \
 && apk add --no-cache --virtual .build-deps \
        build-base linux-headers \
        ruby-dev gnupg \
 && echo 'gem: --no-document' >> /etc/gemrc \
 && gem install oj -v 3.10.18 \
 && gem install json -v 2.4.1 \
 && gem install async-http -v 0.54.0 \
 && gem install ext_monitor -v 0.1.2 \
 && gem install fluentd -v 1.13.3 \
 && gem install bigdecimal -v 1.4.4 \
# NOTE: resolv v0.2.1 includes the fix for CPU spike issue due to DNS resolver.
# This hack is needed for Ruby 2.6.7, 2.7.3 and 3.0.1. (alpine image is still kept on 2.7.3)
 && gem install resolv -v 0.2.1 \
## for additional plugins here
 && gem install fluent-plugin-prometheus \
 && gem install fluent-plugin-machinist \
 && gem install fluent-plugin-splunk-enterprise \
 && apk del .build-deps \
 && rm -rf /tmp/* /var/tmp/* /usr/lib/ruby/gems/*/cache/*.gem /usr/lib/ruby/gems/2.*/gems/fluentd-*/test

RUN addgroup -S fluent && adduser -S -g fluent fluent \
    # for log storage (maybe shared with host)
    && mkdir -p /fluentd/log \
    # configuration/plugins path (default: copied from .)
    && mkdir -p /fluentd/etc /fluentd/plugins \
    && chown -R fluent /fluentd && chgrp -R fluent /fluentd

COPY fluent.conf /fluentd/etc/
# RUN mkdir -p /fluentd/etc/conf.d
COPY conf.d /fluentd/etc/conf.d
COPY entrypoint.sh /bin/

ENV FLUENTD_CONF="fluent.conf"

ENV LD_PRELOAD=""
# NOTE: resolv v0.2.1 includes the fix for CPU spike issue due to DNS resolver.
# Forcing to load specific version of resolv (instead of bundled by default) is needed for Ruby 2.6.7, 2.7.3 and 3.0.1.
# alpine image is still kept on 2.7.3. See https://pkgs.alpinelinux.org/packages?name=ruby&branch=v3.13
ENV RUBYLIB="/usr/lib/ruby/gems/2.7.0/gems/resolv-0.2.1/lib"
EXPOSE 24224 5140

USER fluent
ENTRYPOINT ["tini",  "--", "/bin/entrypoint.sh"]
CMD ["fluentd"]
