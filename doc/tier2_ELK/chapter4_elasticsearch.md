# Elasticsearch

Elasticsearch is a real-time distributed search and analytics engine [4][6]. It allows one to explore data at a speed and at a scale never before possible. It is used for full-text search, structured search, analytics, and all in combination. Elasticsearch is an open-source search engine built on top of Apache Lucene, a fulltext search-engine library. However, Elasticsearch is much more than just Lucene and much more than just full-text search. It can also be described as follows:

* A distributed real-time document store where every field is indexed and searchable
* A distributed search engine with real-time analytics
* Capable of scaling to hundreds of servers and petabytes of structured and unstructured data

And it packages up all this functionality into a standalone server that applications can talk to via a simple RESTful API, using a web client from our favorite programming language, or even from the command line.

For instance, after starting our service up, our simplest example is directly sending a query to the Elasticsearch instance (port 9200 in this case) and get number of indices stored.

      $ curl 'localhost:9200/_cat/indices?v'

      health status index                  uuid                   pri rep docs.count
      yellow open   dcache-billing-2017.10 9ocm5mfoQX255Z8Z4NWwrA   5   1   33336024
      yellow open   dcache-billing-2017.09 bz1ZBIa4SmqetFGBpqruWA   5   1   17306766
      yellow open   dcache-billing-2018.02 iFuFB03PR_SsNNpf6sXpxw   5   1   25118420
      yellow open   dcache-billing-2018.01 HitUUihaRuGBnd47Ma98Bg   5   1   24001272
      yellow open   dcache-billing-2017.05 rnU_rxhcTt6Y-D6AeWxy8A   5   1   23641828
      yellow open   dcache-billing-2017.11 8s3hp4lBRzatjMzXDaNbUQ   5   1   49539540
      yellow open   dcache-billing-2018.04 vRUN0b08T4iZrvyNpxOcgA   5   1   26639090
      yellow open   dcache-billing-2018.12 GFhoMTqfSWKO80lp6iurfg   5   1   63447534
      yellow open   dcache-billing-2017.07 cleYoAc-QM2DgcpfiJnj6Q   5   1   31308502
      yellow open   dcache-billing-2018.11 QJxVUAqESSOGumiG5lk1cA   5   1   48383944
      yellow open   dcache-billing-2018.07 gfCszQ_4RUulIjn42guNUw   5   1   16616834
      green  open   .kibana                E-J_GSkdRj22BN7DQHMN_Q   1   0         27
      yellow open   dcache-billing-2019.04 A9Ic3--tQjaML_Zg_daFXA   5   1   11335536
      yellow open   dcache-billing-2018.09 MkD363YHRUqsIAZvTMCsCA   5   1   29330778
