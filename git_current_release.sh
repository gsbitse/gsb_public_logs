#!/bin/sh

rm -rf gsb_public
git clone git@github.com:gsb-public/gsb_public.git
cd gsb_public
git for-each-ref --sort=-committerdate --format='%(refname:short)' | grep release | cut -c8- | awk 'NR==1'
cd ..
