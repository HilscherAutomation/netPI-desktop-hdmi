## Desktop (Xfce)

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

STEP 4. Press the button **Actions > Start/Deploy container**

Pulling the image may take a while (5-10mins). Sometimes it takes so long that a time out is indicated. In this case repeat the **Actions > Start/Deploy container** action.

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
