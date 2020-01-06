# https://github.com/elastic/kibana-docker
#FROM docker.elastic.co/kibana/kibana:5.6.3
FROM docker.elastic.co/kibana/kibana:6.3.2
#FROM docker.elastic.co/kibana/kibana:7.2.0

# Add your kibana plugins setup here
# Example: RUN kibana-plugin install <name|url>


# SSH configuration
USER root

## Adding kbn_network plugin
RUN yum -y install epel-release; yum -y install git npm
#RUN cd /usr/share/kibana/plugins; git clone https://github.com/dlumbrer/kbn_network.git network_vis -b 6.4-dev; cd network_vis; rm -rf images; npm install


## Overwriting the kibana-docker script
ADD kibana-docker /usr/local/bin/kibana-docker



