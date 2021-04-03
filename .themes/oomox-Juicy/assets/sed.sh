#!/bin/sh
sed -i \
         -e 's/#171a1f/rgb(0%,0%,0%)/g' \
         -e 's/#ffffff/rgb(100%,100%,100%)/g' \
    -e 's/#131519/rgb(50%,0%,0%)/g' \
     -e 's/#ffffff/rgb(0%,50%,0%)/g' \
     -e 's/#171a1f/rgb(50%,0%,50%)/g' \
     -e 's/#ffffff/rgb(0%,0%,50%)/g' \
	"$@"
