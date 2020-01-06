#!/bin/bash

cd $(dirname $0)


## For Kibana
kibana_port=$1
[ -z "$kibana_port" ] && kibana_port=5601
if [ ! -e /tmp/kibana_dashboard.$UID ]; then
    curl -u elastic:changeme -k -XPOST "http://localhost:${kibana_port}/api/kibana/dashboards/import" -H 'Content-Type: application/json' -H "kbn-xsrf: true" -d @export.json
    [ $? -ne 0 ] && exit -1
    date > /tmp/kibana_dashboard.$UID
fi

## For Elasticsearch
elastic_url=$(grep elasticsearch.url /usr/share/kibana/config/kibana.yml | awk '{print $2}')
[ -z "$elastic_url" ] && echo "elastic_url is null" && exit -1
curl -XPUT "${elastic_url}/_template/dcache-billing" -H 'Content-Type: application/json' -d @mapping.json
[ $? -ne 0 ] && "Failed: making template in [$elastic_url]" && exit -1

echo "Success: making template in [$elastic_url]"
exit 0
