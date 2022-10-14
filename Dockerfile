FROM fluent/fluentd:v1.14.6-debian-1.0

## BEGIN customize plugins
##  per https://github.com/fluent/fluentd-docker-image/blob/master/README.md#3-customize-dockerfile-to-install-plugins-optional

# Use root account to use apt
USER root

# below RUN includes plugin as examples elasticsearch is not required
# you may customize including plugins as you wish
RUN buildDeps="sudo make gcc g++ libc-dev" \
 && apt-get update \
 && apt-get install -y --no-install-recommends $buildDeps \
 && sudo gem install \
    fluent-plugin-newrelic \
 && sudo gem sources --clear-all \
 && SUDO_FORCE_REMOVE=yes \
    apt-get purge -y --auto-remove \
                  -o APT::AutoRemove::RecommendsImportant=false \
                  $buildDeps \
 && rm -rf /var/lib/apt/lists/* \
 && rm -rf /tmp/* /var/tmp/* /usr/lib/ruby/gems/*/cache/*.gem

#COPY fluent.conf /fluentd/etc/
#COPY entrypoint.sh /bin/

USER fluent

## END customize plugins