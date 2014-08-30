from centos:centos6
MAINTAINER Ryan Bauman <ryanbauman@gmail.com>

#add EPEL repo 
RUN yum install -y http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm

#add REDHAWK repo and install redhawk
ADD redhawk.repo /etc/yum.repos.d/
RUN yum install -y redhawk-devel redhawk-sdrroot-dev-mgr redhawk-sdrroot-dom-mgr redhawk-sdrroot-dom-profile redhawk-codegen redhawk-basic-components bulkioInterfaces burstioInterfaces frontendInterfaces GPP

#install omniORB-utils
RUN yum install -y omniORB-utils omniORB-servers omniEvents-server omniEvents-bootscripts

#configure omniORB.cfg; Note: if linking another container, replace IP address
#e.g. sed -i "s/127.0.0.1/$OMNIORB_PORT_2809_TCP_ADDR/" /etc/omniORB.cfg
RUN echo "InitRef = EventService=corbaloc::127.0.0.1:11169/omniEvents" >> /etc/omniORB.cfg

#install some other helpful tools
RUN yum install -y git vim-enhanced which wget

#configure default user
RUN mkdir -p /home/redhawk
ADD bashrc /home/redhawk/.bashrc
ADD bash_profile /home/redhawk/.bash_profile
RUN chown -R redhawk. /home/redhawk
RUN usermod -a -G wheel --shell /bin/bash redhawk

#install sudo
RUN yum install -y sudo
#allow sudo access sans password
RUN echo "%wheel        ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers

#install basic gtk support
RUN yum install -y PackageKit-gtk-module libcanberra-gtk2

ENV HOME /home/redhawk
WORKDIR /home/redhawk
USER redhawk
EXPOSE 2809
EXPOSE 11169
CMD ["/bin/bash", "-l"]
