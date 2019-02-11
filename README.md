## Desktop

[![](https://images.microbadger.com/badges/image/hilschernetpi/netpi-desktop-hdmi.svg)](https://microbadger.com/images/hilschernetpi/netpi-desktop-hdmi "Desktop")
[![](https://images.microbadger.com/badges/commit/hilschernetpi/netpi-desktop-hdmi.svg)](https://microbadger.com/images/hilschernetpi//netpi-desktop-hdmi "Desktop")
[![Docker Registry](https://img.shields.io/docker/pulls/hilschernetpi/netpi-desktop-hdmi.svg)](https://registry.hub.docker.com/u/hilschernetpi/netpi-desktop-hdmi/)&nbsp;
[![Image last updated](https://img.shields.io/badge/dynamic/json.svg?url=https://api.microbadger.com/v1/images/hilschernetpi/netpi-desktop-hdmi&label=Image%20last%20updated&query=$.LastUpdated&colorB=007ec6)](http://microbadger.com/images/hilschernetpi/netpi-desktop-hdmi "Image last updated")&nbsp;

Made for [netPI](https://www.netiot.com/netpi/), the Raspberry Pi 3B Architecture based industrial suited Open Edge Connectivity Ecosystem 

### Debian with X.org display server, desktop Xfce, VNC and ALSA audio

The image provided hereunder deploys a container with installed Debian, display server, desktop environment and ssh server.

Base of this image builds [debian](https://www.balena.io/docs/reference/base-images/base-images/) with installed display server [X.org](https://en.wikipedia.org/wiki/X.Org_Server) enabling the device's HDMI port plus the desktop environment [Xfce](https://www.xfce.org/?lang=en) turning the device in a desktop computer with mouse and keyboard support. Additonally it embeds the [ALSA](https://wiki.debian.org/ALSA) Audio Sound package for sending the sound across HDMI. Also the [x11vnc](https://en.wikipedia.org/wiki/X11vnc) server is installed to access to the desktop screen from remote via VNC clients.

#### Container prerequisites

##### Host devices

The following host devices need to be exposed to the container

* **for HDMI support** the devices `/dev/tty0`,`/dev/tty2`,`/dev/fb0`
* **for mouse and keyboard support** the device `/dev/input`
* **for sound over HDMI support** the device `/dev/snd`

##### Privileged mode

The privileged mode option needs to be activated to lift the standard Docker enforced container limitations. With this setting the container and the applications inside are the getting (almost) all capabilities as if running on the Host directly. 

netPI's secure reference software architecture prohibits root access to the Host system always. Even if priviledged mode is activated the intrinsic security of the Host Linux Kernel can not be compromised.

##### Host network

The container needs the Docker "Host" network stack to be shared with the container. 

Hint: Using this mode makes port mapping unnecessary since all the container's used ports are exposed to the host. This is why the container's used SSH server port `22` and VNC port `5900` are getting available on the host without a discrete port mapping.

#### Getting started

##### On netPI

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

#### Accessing

The container starts the desktop, the SSH server and VNC server automatically when started.

In desktop mode make sure you have a mouse and keyboard connected before you start the container, else they will not be recognized. A HDMI monitor will only be recognized if it was already connected during netPI's boot sequence, else its screen remains black. For simple tests use Chromium to do some web page visits.

Alternatively login from remote via a VNC client such as [uVNC](https://www.uvnc.com/) to netPI's IP address at port `5900` to display the screen on another computer. Use the password `mypassword` when asked in your client.

Another alternative is to login to the container with an SSH client such as [putty](http://www.putty.org/) using netPI's IP address at port `22`. Use the credentials `testuser` as user and `mypassword` as password when asked and you are logged in as user testuser.

#### Automated build

The project complies with the scripting based [Dockerfile](https://docs.docker.com/engine/reference/builder/) method to build the image output file. Using this method is a precondition for an [automated](https://docs.docker.com/docker-hub/builds/) web based build process on DockerHub platform.

DockerHub web platform is x86 CPU based, but an ARM CPU coded output file is needed for Raspberry systems. This is why the Dockerfile includes the [balena](https://balena.io/blog/building-arm-containers-on-any-x86-machine-even-dockerhub/) steps.

#### License

View the license information for the software in the project. As with all Docker images, these likely also contain other software which may be under other licenses (such as Bash, etc from the base distribution, along with any direct or indirect dependencies of the primary software being contained).
As for any pre-built image usage, it is the image user's responsibility to ensure that any use of this image complies with any relevant licenses for all software contained within.

[![N|Solid](http://www.hilscher.com/fileadmin/templates/doctima_2013/resources/Images/logo_hilscher.png)](http://www.hilscher.com)  Hilscher Gesellschaft fuer Systemautomation mbH  www.hilscher.com
