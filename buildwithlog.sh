#!/bin/bash

./site-builder.sh 2>&1 | tee make_$(date +%y%m%d_%H%M).log
