#!/bin/bash

./site-builder 2>&1 | tee ../log/make_$(date +%y%m%d_%H%M).log
