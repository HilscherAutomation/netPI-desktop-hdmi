#use fixed armv7hf compatible debian version from group resin.io as base image
FROM resin/armv7hf-debian:stretch

#enable building ARM container on x86 machinery on the web (comment out next line if built on Raspberry) 
RUN [ "cross-build-start" ]

#labeling
LABEL maintainer="netpi@hilscher.com" \ 
      version="V1.2.1" \
      description="Desktop (HDMI) for netPI"

#version
ENV HILSCHERNETPI_DESKTOP_HDMI_VERSION 1.2.1

ENV USER=testuser
ENV PASSWD=mypassword

#copy files
COPY "./init.d/*" /etc/init.d/

#do user
RUN apt-get update \
    && useradd --create-home --shell /bin/bash $USER \
    && echo $USER:$PASSWD | chpasswd \
    && adduser $USER tty \
    && adduser $USER video \
    && adduser $USER sudo \
    && adduser $USER input \
    && echo $USER " ALL=(root) NOPASSWD:ALL" >> /etc/sudoers.d/$USER \
    && chmod 0440 /etc/sudoers.d/$USER

#install ssh
RUN apt-get update  \
    && apt-get install -y openssh-server \
    && sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd \
    && mkdir /var/run/sshd 

#install xserver, desktop, login manager, ALSA sound driver
RUN apt-get install --no-install-recommends xserver-xorg \
    && apt-get install --no-install-recommends xinit \
    && apt-get install xfce4 xfce4-terminal \
    && mkdir /etc/X11/xorg.conf.d \
    && chmod u+s /usr/bin/Xorg \
    && chown -c $USER /etc/X11/xorg.conf.d \
    && apt-get install xserver-xorg-input-evdev \
    && apt-get install gnome-icon-theme tango-icon-theme \
    && apt-get install alsa-oss alsa-tools alsa-tools-gui alsa-utils alsamixergui mpg123 \
    && touch /home/$USER/.Xauthority \
    && chmod 777 /home/$USER/.Xauthority

#install VNC
RUN apt-get install x11vnc \
    && mkdir /home/$USER/.vnc \
    && chown $USER:$USER /home/$USER/.vnc \
    && x11vnc -storepasswd "$PASSWD" /home/$USER/.vnc/passwd \
    && chown $USER:$USER /home/$USER/.vnc/passwd

#install pulseaudio
RUN apt-get install dbus-x11 pulseaudio \
    && sed -i -e 's;load-module module-console-kit;#load-module module-console-kit;' /etc/pulse/default.pa \
    && usermod -a -G audio $USER \
    && usermod -a -G pulse $USER \
    && usermod -a -G pulse-access $USER
    
#install chromium browser
RUN apt-get install wget \
    && wget -O key.pgp https://bintray.com/user/downloadSubjectPublicKey?username=bintray \
    && apt-key add key.pgp \
    && echo "deb http://dl.bintray.com/kusti8/chromium-rpi jessie main" | tee -a /etc/apt/sources.list \
    && apt-get update \
    && apt-get install chromium-browser \
    && rm key.pgp

#set the entrypoint
ENTRYPOINT ["/etc/init.d/entrypoint.sh"]

#SSH port
EXPOSE 22

#set STOPSGINAL
STOPSIGNAL SIGTERM

#stop processing ARM emulation (comment out next line if built on Raspberry)
RUN [ "cross-build-end" ]

#start container as non-root user, else chromium will not run
USER $USER
