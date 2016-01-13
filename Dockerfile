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

# Define REDHAWK environment
ENV OSSIEHOME /usr/local/redhawk/core
ENV SDRROOT /var/redhawk/sdr
ENV PYTHONPATH ${OSSIEHOME}/lib64/python:${OSSIEHOME}/lib/python
ENV PATH ${OSSIEHOME}/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# Configure default user
ENV RHUSER redhawk
ENV HOME /home/${RHUSER}
RUN mkdir -p ${HOME}
RUN cp /etc/skel/.bash* ${HOME}
RUN chown -R ${RHUSER}. ${HOME}
RUN usermod -a -G wheel --shell /bin/bash ${RHUSER}
RUN echo "%wheel        ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers

# Switch to the user and change to user directory
USER ${RHUSER}
WORKDIR ${HOME}

# Downstream image kicks off as root user
# And gains environment variables
ONBUILD USER root
ONBUILD ENV RHUSER ${RHUSER}
ONBUILD ENV HOME ${HOME}
ONBUILD ENV OSSIEHOME ${OSSIEHOME}
ONBUILD ENV SDRROOT ${SDRROOT}
ONBUILD ENV PYTHONPATH ${PYTHONPATH}
ONBUILD ENV PATH ${PATH}

# Expose omni's ports
EXPOSE 2809
EXPOSE 11169

CMD ["/bin/bash", "-l"]
