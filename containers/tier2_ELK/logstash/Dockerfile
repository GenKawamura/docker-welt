# https://github.com/elastic/logstash-docker
#FROM docker.elastic.co/logstash/logstash:5.6.3
#FROM docker.elastic.co/logstash/logstash:6.5.4
FROM docker.elastic.co/logstash/logstash:7.2.0

# Add your logstash plugins setup here
# Example: RUN logstash-plugin install logstash-filter-json

## Replacing docker-entrypoint
ADD logstash.yml /usr/share/logstash/config/
ADD docker-entrypoint /usr/local/bin/
