#!/bin/bash +e
# catch signals as PID 1 in a container

pidpulse=0

# SIGNAL-handler
term_handler() {
  
  echo "terminating dbus ..."
  sudo /etc/init.d/dbus stop
  
  echo "terminating pulseaudio ..."
  if [ $pidpulse -ne 0 ]; then
        kill -SIGTERM "$pidpulse"
        wait "$pidpulse"
  fi
  
  exit 143; # 128 + 15 -- SIGTERM
}

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
pidpulse="$!"

echo "starting dbus ..."
sudo /etc/init.d/dbus start

echo "starting X ..."
/usr/bin/startx &

# wait forever not to exit the container
while true
do
  tail -f /dev/null & wait ${!}
done

exit 0
