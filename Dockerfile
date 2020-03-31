FROM gcr.io/google_containers/pause-amd64:3.0 as pause

FROM ruby:2.6

COPY Gemfile /tmp/

RUN DEBIAN_FRONTEND=noninteractive apt-get update \
	&& DEBIAN_FRONTEND=noninteractive apt-get -y dist-upgrade \
	&& DEBIAN_FRONTEND=noninteractive apt-get -y install \
		build-essential \
		libpq-dev \
		libpq5 \
		libsqlite3-0 \
		libsqlite3-dev \
	&& cd /tmp \
	&& bundle install \
	&& cd / \
	&& DEBIAN_FRONTEND=noninteractive apt-get -y purge \
		build-essential \
		libpq-dev \
		libsqlite3-dev \
		linux-libc-dev \
		python2 \
	&& DEBIAN_FRONTEND=noninteractive apt-get -y --purge autoremove \
	&& DEBIAN_FRONTEND=noninteractive apt-get clean \
	&& ( find /var/lib/apt/lists -mindepth 1 -maxdepth 1 -delete || true ) \
	&& ( find /var/tmp -mindepth 1 -maxdepth 1 -delete || true ) \
	&& ( find /tmp -mindepth 1 -maxdepth 1 -delete || true )

COPY --from=pause /pause /
COPY init /sbin/

ENTRYPOINT ["/sbin/init"]
