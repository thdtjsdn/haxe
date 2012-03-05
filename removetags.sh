#!/bin/bash
# find all remote tags and strip down their names
git for-each-ref --format='%(refname)' refs/remotes/tags/ |
cut -d / -f 4 |
while read tag
do
	git tag -d $tag
	echo Removed tag $tag
done