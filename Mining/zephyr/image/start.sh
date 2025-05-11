#!/bin/bash

./xmrig \
  -o $POOL_URL \
  -u $WALLET \
  -p $WORKER \
  --donate-level=$DONATE_LEVEL \
  -t $CPU_THREADS
