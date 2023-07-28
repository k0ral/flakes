#!/bin/sh

grim -t ppm -s 1 -g "$(slurp)" - | swappy -f -
# grimshot --notify copy area
