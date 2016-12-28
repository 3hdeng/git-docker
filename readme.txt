
#===========
$ ../mybash/getcip.sh mygit
172.17.0.2
$ ssh 172.17.0.2
Warning: Permanently added '172.17.0.2' (ECDSA) to the list of known hosts.
Permission denied (publickey).

$ ssh -i git_docker.priv  git@172.17.0.2

Welcome to jkarlos/git-server-docker!
You have successfully authenticated, but I do not
provide interactive shell access.
Connection to 172.17.0.2 closed.

#===
$ git init --bare test1.git
$ docker cp test1.git mygit:/opt/git/repos/

# even default workdir /opt/git/repos
xxx $ docker cp test1.git mygit:

#==== dkr.sh
#!/bin/bash
gitRepo=$HOME/myGitRepos
if [[ "$#" == "1" ]]; then
   gitRepo=$1
fi
docker run --name mygit-server -d \
    -p 5222:22 \
    -v $gitRepo:/opt/git/repos \
    3hdeng/git-server:t0
#    -e "OPTION_NAME=OPTION_VALUE" \
