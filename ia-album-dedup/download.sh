#!/bin/bash

# https://brewster.kahle.org/2022/10/02/pythonistas-up-for-quick-hack-to-test-deduping-78rpm-records-using-document-clustering/

#get the images of the labels (there are 350k of them, but can test with 1000)
ia search "collection:georgeblood" --itemlist | \
    head -n10000 | \
    xargs -L1 -I{} -P16 \
	  ia download {} --no-directories --format="Item Image"

ls *.jpg | xargs -L1 -I{} -P4 tesseract {} {}
