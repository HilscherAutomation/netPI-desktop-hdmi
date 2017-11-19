#use fixed armv7hf compatible debian version from group resin.io as base image
FROM resin/armv7hf-debian:jessie-20171021

#enable building ARM container on x86 machinery on the web (comment out next 3 lines if built on Raspberry) 
ENV QEMU_EXECVE 1
COPY armv7hf-debian-qemu /usr/bin
RUN [ "cross-build-start" ]

#execute all commands as root
USER root

#labeling
LABEL maintainer="netpi@hilscher.com" \ 
      version="V1.1.0.0" \
      description="Desktop (HDMI) for netPI"

#version
ENV HILSCHERNETPI_DESKTOP_HDMI_VERSION 1.1.0.0

#do user
RUN apt-get update \
    && useradd --create-home --shell /bin/bash testuser \
    && echo 'testuser:mypassword' | chpasswd \
    && adduser testuser tty \
    && adduser testuser video \
    && adduser testuser sudo \
    && echo "testuser ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/testuser \
    && chmod 0440 /etc/sudoers.d/testuser

#install xserver, desktop, login manager, ALSA sound driver
RUN apt-get install --no-install-recommends xserver-xorg \
    && apt-get install --no-install-recommends xinit \
    && apt-get install xfce4 xfce4-terminal \
    && mkdir /etc/X11/xorg.conf.d \
    && chmod u+s /usr/bin/Xorg \
    && chown -c testuser /etc/X11/xorg.conf.d \
    && apt-get install gnome-icon-theme tango-icon-theme \
    && apt-get install alsa-base alsa-oss alsa-utils alsa-tools mpg123 \
    && sed -i -e 's;Exec=xfce4-mixer;Exec=sudo xfce4-mixer;' /usr/share/applications/xfce4-mixer.desktop

#install pulseaudio
RUN apt-get install dbus pulseaudio \
    && sed -i -e 's;load-module module-console-kit;#load-module module-console-kit;' /etc/pulse/default.pa \
    && usermod -a -G audio testuser \
    && usermod -a -G pulse testuser \
    && usermod -a -G pulse-access testuser
    
#install chromium browser
RUN apt-get install wget \
    && wget -O key.pgp https://bintray.com/user/downloadSubjectPublicKey?username=bintray \
    && apt-key add key.pgp \
    && echo "deb http://dl.bintray.com/kusti8/chromium-rpi jessie main" | tee -a /etc/apt/sources.list \
    && apt-get update \
    && apt-get install chromium-browser \
    && rm key.pgp

#allow all users to use X11
RUN sed -i -e 's/allowed_users=console/allowed_users=anybody/g' /etc/X11/Xwrapper.config \
    && echo "needs_root_rights=yes">>/etc/X11/Xwrapper.config

#do startscript
COPY "./files-to-copy-to-image/entrypoint.sh" /
RUN chmod +x /entrypoint.sh 
ENTRYPOINT ["/entrypoint.sh"]

#set STOPSGINAL
STOPSIGNAL SIGTERM

#stop processing ARM emulation (comment out next line if built on Raspberry)
RUN [ "cross-build-end" ]

#start container as non-root user, else chromium will not run
USER testuser
