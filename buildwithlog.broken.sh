#!/bin/bash

./site-builder-broken.sh 2>&1 | tee make_$(date +%y%m%d_%H%M).log
