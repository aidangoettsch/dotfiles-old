#!/bin/sh

 mkdir /home/${NEW_USER}/tmp-setup

cp -r files/* /home/${NEW_USER}/tmp-setup/files/
cp -r files/.config /home/${NEW_USER}/tmp-setup/files/
cp -r files/.*rc /home/${NEW_USER}/tmp-setup/files/

sed -i -e s/%USER%/${NEW_USER}/g /home/${NEW_USER}/tmp-setup/files/.config/compton.conf
sed -i -e s/%USER%/${NEW_USER}/g /home/${NEW_USER}/tmp-setup/files/.config/*/*
sed -i -e s/%USER%/${NEW_USER}/g /home/${NEW_USER}/tmp-setup/files/scripts/*
sed -i -e s/%USER%/${NEW_USER}/g /home/${NEW_USER}/tmp-setup/files/.*rc
sed -i -e s/%HOSTNAME%/${NEW_HOSTNAME}/g /home/${NEW_USER}/tmp-setup/files/.config/compton.conf
sed -i -e s/%HOSTNAME%/${NEW_HOSTNAME}/g /home/${NEW_USER}/tmp-setup/files/.config/*/*
sed -i -e s/%HOSTNAME%/${NEW_HOSTNAME}/g /home/${NEW_USER}/tmp-setup/files/scripts/*
sed -i -e s/%HOSTNAME%/${NEW_HOSTNAME}/g /home/${NEW_USER}/tmp-setup/files/.*rc
sed -i -e s\|%DATA_DIR%\|${DATA_DIR}\|g /home/${NEW_USER}/tmp-setup/files/.config/compton.conf
sed -i -e s\|%DATA_DIR%\|${DATA_DIR}\|g /home/${NEW_USER}/tmp-setup/files/.config/*/*
sed -i -e s\|%DATA_DIR%\|${DATA_DIR}\|g /home/${NEW_USER}/tmp-setup/files/scripts/*
sed -i -e s\|%DATA_DIR%\|${DATA_DIR}\|g /home/${NEW_USER}/tmp-setup/files/.*rc

cp -r /home/${NEW_USER}/tmp-setup/files/* /home/${NEW_USER}/
cp -r /home/${NEW_USER}/tmp-setup/files/.config /home/${NEW_USER}/
cp -r /home/${NEW_USER}/tmp-setup/files/.*rc /home/${NEW_USER}/