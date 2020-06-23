#!/bin/bash +e
# catch signals as PID 1 in a container

# SIGNAL-handler
term_handler() {

  echo "stopping x server ..."
  pidxserver=$(pidof "Xorg") 

  sudo kill -SIGTERM "$pidxserver"
  tail --pid=$pidxserver -f /dev/null

  echo "terminating ssh ..."
  sudo /etc/init.d/ssh stop

  exit 143; # 128 + 15 -- SIGTERM
}

#remove locks in case desktop crashed
rm /tmp/.X0-lock &>/dev/null || true
sudo rm  -fr ~/.Xauthority
touch ~/.Xauthority
chmod 777 ~/.Xauthority

#set environment variables
export DISPLAY=:0.0
export XAUTHORITY=~/.Xauthority
export DBUS_SYSTEM_BUS_ADDRESS=unix:path=/var/run/dbus/system_bus_socket

# on callback, stop all started processes in term_handler
trap 'kill ${!}; term_handler' SIGINT SIGKILL SIGTERM SIGQUIT SIGTSTP SIGSTOP SIGHUP

# add input devices and their events to X11 configuration
if test -f /etc/X11/xorg.conf.d/10-input.conf
then
   rm /etc/X11/xorg.conf.d/10-input.conf
fi
# create new input device file
cat > /etc/X11/xorg.conf.d/10-input.conf <<_EOF_
Section "ServerFlags"
     Option "AutoAddDevices" "False"
EndSection
_EOF_

cd /dev/input
for input in event*
do
cat >> /etc/X11/xorg.conf.d/10-input.conf <<_EOF_
    Section "InputDevice"
    Identifier "$input"
    Option "Device" "/dev/input/$input"
    Option "AutoServerLayout" "true"
    Driver "evdev"
EndSection
_EOF_
done

#set ALSA sound to HDMI output
sudo amixer cset numid=3 2     
sudo amixer cset numid=1 100%

# run applications in the background

echo "starting pulseaudio ..."
sudo pulseaudio --system --high-priority --no-cpu-limit -v -L 'module-alsa-sink device=plughw:0,1' >/dev/null 2>&1 &

echo "starting SSH server ..."
if [ "$SSHPORT" ]; then
  #there is an alternative SSH port configured
  echo "the container binds the SSH server port to the configured port $SSHPORT"
  sudo sed -i -e "s;#Port 22;Port $SSHPORT;" /etc/ssh/sshd_config
else
  echo "the container binds the SSH server port to the default port 22"
fi
sudo /etc/init.d/ssh start

#set rights
sudo chmod -R 777 /dev/tty0
sudo chmod -R 777 /dev/tty1
sudo chmod -R 777 /dev/tty2
sudo chmod -R 777 /dev/snd
sudo chmod -R 777 /dev/input
sudo chmod -R 777 /dev/fb0

echo "starting X on display 0 ..."
/usr/bin/startx -- :0 &
sleep 10

echo "starting VNC ..."
/usr/bin/vncserver-x11 &

echo "starting anydesk ..."
/usr/bin/anydesk &

# wait forever not to exit the container
while true
do
  tail -f /dev/null & wait ${!}
done

exit 0
