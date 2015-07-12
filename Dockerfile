FROM centos:6
MAINTAINER Ryan Bauman <ryanbauman@gmail.com>

COPY redhawk.repo /etc/yum.repos.d/

RUN yum update -y && \
    yum install -y epel-release && \
    yum install -y redhawk-devel \
                   redhawk-sdrroot-dev-mgr \
                   redhawk-sdrroot-dom-mgr \
                   redhawk-sdrroot-dom-profile \
                   redhawk-codegen \
                   redhawk-basic-components \
                   bulkioInterfaces \
                   burstioInterfaces \
                   frontendInterfaces \
                   GPP \
                   omniORB-servers \
                   omniEvents-bootscripts \
                   sudo && \
    yum clean all

COPY omniORB.cfg /etc/

#configure default user
RUN mkdir -p /home/redhawk
RUN cp /etc/skel/.bash* /home/redhawk && chown -R redhawk. /home/redhawk
RUN usermod -a -G wheel --shell /bin/bash redhawk
RUN echo "%wheel        ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers

#Define environment
ENV HOME /home/redhawk
ENV OSSIEHOME /usr/local/redhawk/core
ENV SDRROOT /var/redhawk/sdr
ENV PYTHONPATH /usr/local/redhawk/core/lib64/python:/usr/local/redhawk/core/lib/python
ENV PATH /usr/local/redhawk/core/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
WORKDIR /home/redhawk
USER redhawk

#Run nodeconfig
RUN /var/redhawk/sdr/dev/devices/GPP/python/nodeconfig.py --silent \
    --clean \
    --gpppath=/devices/GPP \
    --disableevents \
    --domainname=REDHAWK_DEV \
    --sdrroot=/var/redhawk/sdr \
    --inplace \
    --nodename DevMgr_default

ONBUILD USER root

EXPOSE 2809
EXPOSE 11169
CMD ["/bin/bash", "-l"]
