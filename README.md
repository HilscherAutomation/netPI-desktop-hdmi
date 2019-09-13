## Desktop

[![](https://images.microbadger.com/badges/image/hilschernetpi/netpi-desktop-hdmi.svg)](https://microbadger.com/images/hilschernetpi/netpi-desktop-hdmi "Desktop")
[![](https://images.microbadger.com/badges/commit/hilschernetpi/netpi-desktop-hdmi.svg)](https://microbadger.com/images/hilschernetpi//netpi-desktop-hdmi "Desktop")
[![Docker Registry](https://img.shields.io/docker/pulls/hilschernetpi/netpi-desktop-hdmi.svg)](https://registry.hub.docker.com/u/hilschernetpi/netpi-desktop-hdmi/)&nbsp;
[![Image last updated](https://img.shields.io/badge/dynamic/json.svg?url=https://api.microbadger.com/v1/images/hilschernetpi/netpi-desktop-hdmi&label=Image%20last%20updated&query=$.LastUpdated&colorB=007ec6)](http://microbadger.com/images/hilschernetpi/netpi-desktop-hdmi "Image last updated")&nbsp;

Made for [netPI](https://www.netiot.com/netpi/), the Raspberry Pi 3B Architecture based industrial suited Open Edge Connectivity Ecosystem 

### Secured netPI Docker

netPI features a restricted Docker protecting the system software's integrity by maximum. The restrictions are 

* privileged mode is not automatically adding all host devices `/dev/` to a container
* volume bind mounts to rootfs is not supported
* the devices `/dev`,`/dev/mem`,`/dev/sd*`,`/dev/dm*`,`/dev/mapper`,`/dev/mmcblk*` cannot be added to a container

### Container features

The image provided hereunder deploys a container with installed Debian, display server, desktop environment, virtual network computing, remote desktop software and ssh server.

Base of this image builds [debian](https://www.balena.io/docs/reference/base-images/base-images/) with installed HDMI display server [X.org](https://en.wikipedia.org/wiki/X.Org_Server) and a desktop environment [Xfce](https://www.xfce.org/?lang=en) turning the device in a desktop PC. The [ALSA](https://wiki.debian.org/ALSA) audio sound package outputs on HDMI. The [REALVNC](https://www.realvnc.com/) server enables the access from remote via VNC clients, while the [AnyDesk](https://anydesk.com/) server the access over the internet.

### Container setup

#### Port mapping, network mode

The container needs to run in `host` network mode.

Using this mode makes port mapping unnecessary since all the used container ports (like 22) are exposed to the host automatically.

#### Host devices

The following host devices need to be added to the container

* **for HDMI support** the devices `/dev/tty0`,`/dev/tty2`,`/dev/fb0`
* **for mouse and keyboard support** the device `/dev/input`
* **for sound over HDMI support** the device `/dev/snd`

#### Privileged mode

The privileged mode option needs to be activated to lift the standard Docker enforced container limitations. With this setting the container and the applications inside are the getting (almost) all capabilities as if running on the Host directly. 

### Container deployment

STEP 1. Open netPI's website in your browser (https).

STEP 2. Click the Docker tile to open the [Portainer.io](http://portainer.io/) Docker management user interface.

STEP 3. Enter the following parameters under *Containers > + Add Container*

Parameter | Value | Remark
:---------|:------ |:------
*Image* | **hilschernetpi/netpi-desktop-hdmi**
*Network > Network* | **Host** |
*Restart policy* | **always**
*Runtime > Devices > +add device* | *Host path* **/dev/tty0** -> *Container path* **/dev/tty0** | 
*Runtime > Devices > +add device* | *Host path* **/dev/tty2** -> *Container path* **/dev/tty2** | 
*Runtime > Devices > +add device* | *Host path* **/dev/fb0** -> *Container path* **/dev/fb0** | 
*Runtime > Devices > +add device* | *Host path* **/dev/input** -> *Container path* **/dev/input** | 
*Runtime > Devices > +add device* | *Host path* **/dev/snd** -> *Container path* **/dev/snd** | 
*Runtime > Privileged mode* | **On** |

STEP 4. Press the button *Actions > Start/Deploy container*

Pulling the image may take a while (5-10mins). Sometimes it may take too long and a time out is indicated. In this case repeat STEP 4.

### Container access

Make sure you have a mouse and keyboard connected before you start the container else they are not recognized. 

A HDMI monitor in general will only be recognized if it was already connected during netPI's boot sequence else the screen remains black.

The container starts the desktop over HDMI, the SSH server, the VNC server and AnyDesk automatically when deployed.

#### ssh

Login to the container with an SSH client such as [putty](http://www.putty.org/) using netPI's IP address at port `22`. Use the credentials `testuser` as user and `mypassword` as password when asked and you are logged in as user testuser.

#### VNC

Control the desktop with any VNC client over port `5900`. The [REALVNC viewer](https://www.realvnc.com/en/connect/download/viewer/) works right away. For others like [UltraVNC](https://www.uvnc.com/downloads/ultravnc.html) change the authentication method in the server/options/security/authentication settings from `UNIX password` to `VNC password`.

#### AnyDesk

Control the desktop over the internet with [AnyDesk software](https://anydesk.com/en). Use the `This Desk ID` shown on the desktop in the AnyDesk software `Remote Desk ID` field to connect. Accept the connection on the desktop afterwards.

### Container tips & tricks

For additional help or information visit the Hilscher Forum at https://forum.hilscher.com/

### Container automated build

The project complies with the scripting based [Dockerfile](https://docs.docker.com/engine/reference/builder/) method to build the image output file. Using this method is a precondition for an [automated](https://docs.docker.com/docker-hub/builds/) web based build process on DockerHub platform.

DockerHub web platform is x86 CPU based, but an ARM CPU coded output file is needed for Raspberry Pi systems. This is why the Dockerfile includes the [balena](https://balena.io/blog/building-arm-containers-on-any-x86-machine-even-dockerhub/) steps.

#### License

View the license information for the software in the project. As with all Docker images, these likely also contain other software which may be under other licenses (such as Bash, etc from the base distribution, along with any direct or indirect dependencies of the primary software being contained).
As for any pre-built image usage, it is the image user's responsibility to ensure that any use of this image complies with any relevant licenses for all software contained within.

[![N|Solid](http://www.hilscher.com/fileadmin/templates/doctima_2013/resources/Images/logo_hilscher.png)](http://www.hilscher.com)  Hilscher Gesellschaft fuer Systemautomation mbH  www.hilscher.com
