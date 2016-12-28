#!/bin/bash
gitRepo=$HOME/myGitRepos
if [[ "$#" == "1" ]]; then
   gitRepo=$1
fi
USER=git

docker run --name mygit -d \
    -p 5222:22 \
    -v $gitRepo:/opt/$USER/repos \
    3hdeng/git-server:u16
#    -e "OPTION_NAME=OPTION_VALUE" \
