#!/bin/bash
# lets do some bash magic, create an array of all existing tags
declare -a tags=(`git tag`);
# find all remote tags and strip down their names
git for-each-ref --format='%(refname)' refs/remotes/tags/ |
cut -d / -f 4 |
while read tag
do
	# do more bash magic, the next two line check if the tag already
	# exists in git
	echo "${tags[@]}" | grep -qv "$tag"
	if [ $? -eq 0 ]; then
		git tag "$tag" "refs/remotes/tags/$tag" -m "$tag";
	fi
done
