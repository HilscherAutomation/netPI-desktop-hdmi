## Desktop

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![](https://images.microbadger.com/badges/commit/hilschernetpi/netpi-desktop-hdmi.svg)](https://microbadger.com/images/hilschernetpi//netpi-desktop-hdmi "Desktop")
[![Docker Registry](https://img.shields.io/docker/pulls/hilschernetpi/netpi-desktop-hdmi.svg)](https://registry.hub.docker.com/r/hilschernetpi/netpi-desktop-hdmi/)&nbsp;
[![Image last updated](https://img.shields.io/badge/dynamic/json.svg?url=https://api.microbadger.com/v1/images/hilschernetpi/netpi-desktop-hdmi&label=Image%20last%20updated&query=$.LastUpdated&colorB=007ec6)](http://microbadger.com/images/hilschernetpi/netpi-desktop-hdmi "Image last updated")&nbsp;

Made for Raspberry Pi 3B architecture based devices and compatibles

### Container features

The image provided hereunder deploys a container with installed Debian, display server, desktop environment, virtual network computing, remote desktop software and ssh server.

Base of this image builds [debian](https://www.balena.io/docs/reference/base-images/base-images/) with installed HDMI display server [X.org](https://en.wikipedia.org/wiki/X.Org_Server) and a desktop environment [Xfce](https://www.xfce.org/?lang=en) turning the device in a desktop PC. The [ALSA](https://wiki.debian.org/ALSA) audio sound package outputs on HDMI. The [REALVNC](https://www.realvnc.com/) server enables the access from remote via VNC clients, while the [AnyDesk](https://anydesk.com/) server the access over the internet.

### Container hosts

The container has been successfully tested on the following hosts

* netPI, model RTE 3, product name NIOT-E-NPI3-51-EN-RE
* netPI, model CORE 3, product name NIOT-E-NPI3-EN
* netIOT Connect, product name NIOT-E-TPI51-EN-RE
* netFIELD Connect, product name NIOT-E-TPI51-EN-RE/NFLD
* Raspberry Pi, model 3B

netPI devices specifically feature a restricted Docker protecting the Docker host system software's integrity by maximum. The restrictions are

* privileged mode is not automatically adding all host devices `/dev/` to a container
* volume bind mounts to rootfs is not supported
* the devices `/dev`,`/dev/mem`,`/dev/sd*`,`/dev/dm*`,`/dev/mapper`,`/dev/mmcblk*` cannot be added to a container

### Container setup

#### Environment variable (optional)

The container binds the SSH server port to `22` by default.

For an alternative port use the environment variable **SSHPORT** with the desired port number as value.

#### Port mapping, network mode

The container needs to run in `host` network mode.

This mode makes port mapping unnecessary. The following TCP/UDP container ports are exposed to the host automatically

Used port | Protocol | By application | Remark
:---------|:------ |:------ |:-----
*22 or SSHPORT* | TCP | SSH server
*5900* | TCP | VNC server | 

#### Host devices

The following host devices need to be added to the container

* **for HDMI support** the devices `/dev/tty0`,`/dev/tty2`,`/dev/fb0`
* **for mouse and keyboard support** the device `/dev/input`
* **for sound over HDMI support** the device `/dev/snd`

#### Privileged mode

The privileged mode option needs to be activated to lift the standard Docker enforced container limitations. With this setting the container and the applications inside are the getting (almost) all capabilities as if running on the Host directly. 

### Container deployment

Pulling the image may take 10 minutes.

#### netPI example

STEP 1. Open netPI's web UI in your browser (https).

STEP 2. Click the Docker tile to open the [Portainer.io](http://portainer.io/) Docker management user interface.

STEP 3. Enter the following parameters under *Containers > + Add Container*

Parameter | Value | Remark
:---------|:------ |:------
*Image* | **hilschernetpi/netpi-desktop-hdmi**
*Network > Network* | **Host** |
*Restart policy* | **always**
*Runtime > Env* | *name* **SSHPORT** -> *value* **any number value** | optional for different SSH port
*Runtime > Devices > +add device* | *Host path* **/dev/tty0** -> *Container path* **/dev/tty0** | 
*Runtime > Devices > +add device* | *Host path* **/dev/tty2** -> *Container path* **/dev/tty2** | 
*Runtime > Devices > +add device* | *Host path* **/dev/fb0** -> *Container path* **/dev/fb0** | 
*Runtime > Devices > +add device* | *Host path* **/dev/input** -> *Container path* **/dev/input** | 
*Runtime > Devices > +add device* | *Host path* **/dev/snd** -> *Container path* **/dev/snd** | 
*Runtime > Privileged mode* | **On** |

STEP 4. Press the button *Actions > Start/Deploy container*

#### Docker command line example

`docker run -d --privileged --network=host --restart=always -e SSHPORT=22 --device=/dev/tty0:/dev/tty0 --device=/dev/tty2:/dev/tty2 --device=/dev/fb0:/dev/fb0 --device=/dev/input:/dev/input --device=/dev/snd:/dev/snd -p 22:22/tcp -p 5900:5900 hilschernetpi/netpi-desktop-hdmi`

#### Docker compose example

A `docker-compose.yml` file could look like this

    version: "2"

    services:
     desktop:
       image: hilschernetpi/netpi-desktop-hdmi
       restart: always
       privileged: true
       network_mode: host
       ports:
         - 22:22
         - 5900:5900
       devices:
         - "/dev/tty0:/dev/tty0"
         - "/dev/tty2:/dev/tty2"
         - "/dev/fb0:/dev/fb0"
         - "/dev/input:/dev/input"
         - "/dev/snd:/dev/snd"
       environment:
         - SSHPORT=22

### Container access

The container starts the desktop over HDMI, the SSH server, the VNC server and AnyDesk automatically when deployed.

Make sure you have a mouse and keyboard connected before you deploy the container else they are not recognized by it.

A HDMI monitor in general will only be recognized if it was already connected when the device is powered else the screen remains black.

#### ssh

For an SSH terminal session use an SSH client such as [putty](http://www.putty.org/) with the Docker host IP address (@port number `22` or **SSHPORT** or bridge mode mapped one).

Use the credentials `testuser` as user and `mypassword` as password when asked and you are logged in as non-root user `testuser`.

Continue to use [Linux commands](https://www.raspberrypi.org/documentation/linux/usage/commands.md) in the terminal as usual.

#### VNC

Control the desktop with any VNC client over port `5900`. The [REALVNC viewer](https://www.realvnc.com/en/connect/download/viewer/) works right away. For others like [UltraVNC](https://www.uvnc.com/downloads/ultravnc.html) change the authentication method in the server/options/security/authentication settings from `UNIX password` to `VNC password`.

#### AnyDesk

Control the desktop over the internet with [AnyDesk software](https://anydesk.com/en). Use the `This Desk ID` shown on the desktop in the AnyDesk software `Remote Desk ID` field to connect. Accept the connection on the desktop afterwards.

### License

Copyright (c) Hilscher Gesellschaft fuer Systemautomation mbH. All rights reserved.
Licensed under the LISENSE.txt file information stored in the project's source code repository.

As with all Docker images, these likely also contain other software which may be under other licenses (such as Bash, etc from the base distribution, along with any direct or indirect dependencies of the primary software being contained).
As for any pre-built image usage, it is the image user's responsibility to ensure that any use of this image complies with any relevant licenses for all software contained within.

[![N|Solid](http://www.hilscher.com/fileadmin/templates/doctima_2013/resources/Images/logo_hilscher.png)](http://www.hilscher.com)  Hilscher Gesellschaft fuer Systemautomation mbH  www.hilscher.com

