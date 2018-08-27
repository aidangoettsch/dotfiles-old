#!/bin/sh

sed -i -e 's/%USER%/'${NEW_USER}'/g' files/*
sed -i -e 's/%HOSTNAME%/'${NEW_HOSTNAME}'/g' files/*
sed -i -e 's/%DATA_DIR%/'${DATA_DIR}'/g' files/*

cp -r files/* /home/${NEW_USER}/