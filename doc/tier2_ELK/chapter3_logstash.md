# Logstash
Logstash is a tool to collect, process, and forward events and log messages. Collection is accomplished via configurable input plugins including raw socket/packet communication, file tailing, and several message bus clients. There are many built-in patterns and plugins that are supported out-of-the-box by Logstash for filtering items such as words, numbers, and dates. If we cannot find the pattern we need, we can write own custom pattern. In our dCache billing log use-case so far, we put our pattern based on a standard dCache logstash template [4][5].

## Logstash configuraiton for dCache billing log
The pattern and pipeline files are defined by 'customs/\*/logstash/pattern' and 'customs/\*/logstash/pipeline'.


* Some examples of dCache log pattern

The raw information about all dCache activities can be found in /var/lib/dcache/billing/YYYY/MM/billing-YYYY.MM.DD. A typical line looks like

     05.31 22:35:16 [pool:pool-name:transfer] [000100000000000000001320,24675] \
     myStore:STRING@osm 24675 474 true {GFtp-1.0 client-host-fqn 37592} {0:""}

The first bracket contains the pool name, the second the pnfs ID and the size of the file which is transferred. Then follows the storage class, the actual amount of bytes transferred, and the number of milliseconds the transfer took. The next entry is true if the transfer was a wrote data to the pool. The first braces contain the protocol, client FQN, and the client host data transfer listen port. The final bracket contains the return status and a possible error message.
 The billing info keeps such general accountings about the cell, pool, door and actions, such as removal, move and so on, for listing the details of their requests. The output of those requests often contains useful information for describing details of the transfers and solving problems. For instance, the following patterns describe a general (classical) transfer request and a store request. Each accounting line should have appropriate fields such as datetime, PNFS ID, file size, transfered time, protocol, pool or door names, error and so on. The fields are already defined by 'customs/\*/logstash/pattern' and its pattern file is called by 'customs/\*/logstash/pipeline'.


     TRANSFER_CLASSIC %{BILLING_TIME:billing_time} %{CELL_AND_TYPE} %{PNFSID_SIZE} %{PATH} \
     %{SUNIT} %{TRANSFER_SIZE} %{TRANSFER_TIME} %{IS_WRITE} %{PROTOCOL} %{DOOR} %{ERROR}

     STORE_CLASSIC %{BILLING_TIME:billing_time} %{CELL_AND_TYPE} %{PNFSID_TSIZE} %{PATH} \
     %{SUNIT} %{TRANSFER_TIME} %{QUEUE_TIME} %{ERROR}

