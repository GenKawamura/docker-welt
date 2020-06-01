[ ! -e workarea ] && mkdir -v workarea

## Generating Elasticsearch workspace
[ ! -e workarea/elasticsearch_index_data ] && mkdir -v workarea/elasticsearch_index_data
chmod 1777 workarea/elasticsearch_index_data

## Generating Grafana workapace
[ ! -e workarea/grafana ] && mkdir -v workarea/grafana
chmod 1777 workarea/grafana
cp -v grafana/grafana.db workarea/grafana
chmod 666 workarea/grafana/grafana.db
