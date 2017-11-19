## Desktop

Made for [netPI](https://www.netiot.com/netpi/), the Open Edge Connectivity Ecosystem 

### Debian with X.org display server, desktop Xfce and ALSA audio

Base of this image builds a tagged version of [debian:jessie](https://hub.docker.com/r/resin/armv7hf-debian/tags/) with installed display server [X.org](https://en.wikipedia.org/wiki/X.Org_Server) enabling the device's HDMI port plus the desktop environment [Xfce](https://www.xfce.org/?lang=en) turning the device in a desktop computer with mouse and keyboard support. Additonally it embeds the [ALSA](https://wiki.debian.org/ALSA) Audio Sound package for sending the sound across HDMI.

#### Container prerequisites

##### Host devices

The following host devices need to be exposed to the container

* **for HDMI support** the devices `/dev/tty0`,`/dev/tty2`,`/dev/fb0`
* **for mouse and keyboard support** the device `/dev/input`
* **for sound over HDMI support** the device `/dev/snd`

##### Privileged mode

Only the privileged mode option lifts the enforced container limitations to allow usage of X.org display server in a container.

##### Host network

The container needs the "Host" network stack to be shared with the container.

#### Getting started

##### On netPI

STEP 1. Open netPI's landing page under `https://<netpi's ip address>`.

STEP 2. Click the Docker tile to open the [Portainer.io](http://portainer.io/) Docker management user interface.

STEP 3. Enter the following parameters under **Containers > Add Container**

* **Image**: `hilschernetpi/netpi-desktop-hdmi`

* **Network > Network**: `Host`

* **Restart policy"** : `always`

* **Runtime > Privileged mode** : `On`

* **Runtime > Devices > add device**: `Host "/dev/tty0" -> Container "/dev/tty0"`and`Host "/dev/tty2" -> Container "/dev/tty2"`and`Host "/dev/fb0" -> Container "/dev/fb0"`and`Host "/dev/input" -> Container "/dev/input"`and`Host "/dev/snd" -> Container "/dev/snd"`

STEP 4. Press the button **Actions > Start container**

Pulling the image from Docker Hub may take up to 5 minutes.

##### On Pi 3 for test

STEP 1. Establish a [console](https://www.raspberrypi.org/documentation/usage/terminal/README.md) connection to Pi 3.

STEP 2. [Install](https://www.raspberrypi.org/blog/docker-comes-to-raspberry-pi/) Docker if not already done, else skip. 

STEP 3. Run a container instance of the image using the following command line

`docker run 
   --device="/dev/tty0" 
   --device="/dev/tty2" 
   --device="/dev/fb0"
   --device="/dev/input"
   --device="/dev/snd"
   --net=host
   --restart=always
   --privileged
   hilschernetpi/netpi-desktop-hdmi
`

#### Accessing

Make sure you have a mouse and keyboard connected before you start the container, else they will not be recognized. A HDMI monitor will only be recognized if it was already connected during netPI'S boot sequence, else its screen remains black. For simple tests use Firefox (icewaesel) to do some web page visits.

#### Tags

* **hilscher/netPI-desktop-hdmi:latest** - non-versioned latest development output of the master branch. Shouldn't be used since under development all the time.

* **hilscher/netPI-desktop-hdmi:0.9.1.0** - runs with netPI's system software version V0.9.1.0. In this version the dbus host socket needs to be exposed to the container to run bluetooth **Volumes > Volume mapping > map additional volume** : `container: /var/run/docker.sock (bind)-> volume: /var/run/docker.sock(writeable)`.

* **hilscher/netPI-desktop-hdmi:1.1.0.0** - runs with netPI's system software version V1.1.0.0.

#### GitHub sources
The image is built from the GitHub project [netPI-desktop-hdmi](https://github.com/hilscher/netPI-desktop-hdmi). It complies with the [Dockerfile](https://docs.docker.com/engine/reference/builder/) method to build a Docker image [automated](https://docs.docker.com/docker-hub/builds/).

To build the container for an ARM CPU on [Docker Hub](https://hub.docker.com/)(x86 based) the Dockerfile uses the method described here [resin.io](https://resin.io/blog/building-arm-containers-on-any-x86-machine-even-dockerhub/).

[![N|Solid](http://www.hilscher.com/fileadmin/templates/doctima_2013/resources/Images/logo_hilscher.png)](http://www.hilscher.com)  Hilscher Gesellschaft fuer Systemautomation mbH  www.hilscher.com
