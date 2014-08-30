# REDHAWK docker
A basic [Docker](https://www.docker.com/) image of a [REDHAWK](http://redhawksdr.org) development environment.

The image can be pulled from the [Docker Hub Registry](https://registry.hub.docker.com/u/ryanbauman/redhawk/)

The default command for this image runs a bash shell as the 'redhawk' user.  This is a privileged user and is not required to authenticate when running 'sudo' so that the container may be customized.

	docker run -i -t ryanbauman/redhawk

The image comes with the omniNames and omniEvents servers installed and configured.  Start them with:

    sudo service omniNames start
    sudo service omniEvents start

#REDHAWK IDE support
The REDHAWK IDE has been intentionally omitted from the yum repository this image draws from. To enable IDE support in your docker container, download the standalone IDE from sourceforge and invoke the image appropriately.

If you are on an SELinux enabled host, assign the appropriate context to the /tmp/.X11-unix directory as described [here]( https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/7/html/Resource_Management_and_Linux_Containers_Guide/sec-Sharing_Data_Across_Containers.html):

    chcon -Rt svirt_sandbox_file_t /tmp/.X11-unix

Additionally, disable xhost access control:

    xhost +

Run the image and mount the volume to the container.  Additionally, set the display environment variable:

    docker run -i -t --volume=/tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=unix$DISPLAY ryanbauman/redhawk

At the shell prompt, retrieve the REDHAWK IDE from sourceforge and unpack it:

    curl -L http://sourceforge.net/projects/redhawksdr/files/redhawk/1.10.0/el6/x86_64/redhawk-ide-1.10.0.R201407290010-linux.gtk.x86_64.tar.gz |tar zx

Verify that the REDHAWK IDE can be launched and displays correctly on the host system:

    ./eclipse/eclipse &


