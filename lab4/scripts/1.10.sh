#!/bin/bash

find ~ -maxdepth 1 -exec du -h -s {} \; | sort -nr
