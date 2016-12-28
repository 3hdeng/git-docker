#!/bin/bash
# sudo aa-complain /etc/apparmor.d/docker
imgname=3hdeng/git-server:u16
docker run -it --name mydkit  $imgname /bin/bash



