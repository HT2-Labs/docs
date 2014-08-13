#!/usr/bin/env sh

# Colours
START='\e['
CYAN='${START}0;36m'
NC='${START}0m'

# Build
echo "${CYAN}Starting build${NC}"
rm -rf out || exit 0
mkdir out
gem install jekyll
jekyll build --destination out
echo "${CYAN}Finished build${NC}"

# Branch
BRANCH=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')
MASTER="master"

# Deploy if on master branch
if [ "${MASTER}" == "${BRANCH}" ]; then
	( echo "${CYAN}Starting deployment${NC}"
	 cd out
	 git init
	 git config user.name "Travis-CI"
	 git config user.email "travis@nodemeatspace.com"
	 cp ../CNAME ./CNAME
	 cp ../countryiso.js ./countryiso.js
	 git add .
	 git commit -m "Deployed to Github Pages"
	 git push --force --quiet "https://${GH_TOKEN}@${GH_REF}" master:gh-pages > /dev/null 2>&1
	 echo "${CYAN}Finished deployment${NC}"
	)
fi
