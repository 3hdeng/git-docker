# https://hub.docker.com/r/casadocker/git-server/~/dockerfile/
# https://github.com/bankiru/docker-git-daemon
# https://hub.docker.com/r/gitlab/gitlab-ce/~/dockerfile/
###########################################################################
#
# .) Build
# docker build --no-cache -t 3hdeng/git-server:16.04 .
# .) Run
# docker-compose up -d
#
##################################

FROM ubuntu:16.04
MAINTAINER 3hdeng


#rm supervisor; git or git-core ? 
#RUN apt-get install -y openssh-server git
RUN apt-get update -q \
    && DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
      ca-certificates \
      openssh-server git

# SSH
RUN mkdir -p /var/run/sshd
RUN sed -ri 's/PermitRootLogin prohibit-password/PermitRootLogin no/g' /etc/ssh/sshd_config
RUN sed -ri 's/#PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config
RUN sed -ri 's/#UseLogin no/UseLogin no/g' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/UsePAM no/g' /etc/ssh/sshd_config



RUN chown root /var/run && chown root /var/run/sshd


ENV USER git
RUN adduser --disabled-password --shell /usr/bin/git-shell --gecos "" $USER
RUN adduser $USER sudo

# This is a login shell for SSH accounts to provide restricted Git access.
# It permits execution only of server-side Git commands implementing the
# pull/push functionality, plus custom commands present in a subdirectory
# named git-shell-commands in the user’s home directory.
# More info: https://git-scm.com/docs/git-shell
COPY files/git-shell-commands /home/$USER/git-shell-commands


RUN mkdir -p /home/$USER/.ssh
RUN chmod 700 /home/$USER/.ssh
COPY files/git_docker.pub /home/$USER/.ssh/authorized_keys
RUN chmod 600 /home/$USER/.ssh/authorized_keys
RUN chown -R $USER:$USER /home/$USER/.ssh
RUN mkdir -p /opt/$USER/repos
RUN chmod 0775 /opt/$USER/repos
RUN chown -R $USER:$USER /opt/$USER/repos

COPY files/start.sh /opt/ 
RUN chmod u+x /opt/start.sh

# RUN ssh-keygen -A
COPY files/ssh_host* /etc/ssh/
RUN chmod 0444 /etc/ssh/ssh_host*
WORKDIR /opt/$USER/repos

EXPOSE 22

CMD ["/opt/start.sh"]
