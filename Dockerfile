FROM gcr.io/google_containers/pause-amd64:3.0 as pause

FROM ruby:2.6

COPY Gemfile /tmp/

RUN apt-get update \
	&& apt-get install -y libpq5 libsqlite3-0 \
	&& apt-get install -y libpq-dev libsqlite3-dev build-essential \
	&& cd /tmp \
	&& bundle install \
	&& cd / \
	&& apt-get purge -y libpq-dev build-essential libsqlite3-dev \
	&& apt-get -y --purge autoremove \
	&& apt-get clean \
	&& rm -rf /tmp/* /tmp/.bundle /var/lib/apt/lists/*

COPY --from=pause /pause /
COPY init /sbin/

ENTRYPOINT ["/sbin/init"]
