#!/bin/bash

mkdir /var/spool/condor
$(condor_config_val Master) -f -t 2>&1 | tee /var/log/condor/MasterLog
