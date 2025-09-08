#!/bin/bash

gnome-extensions disable caffeine@patapon.info
sleep 1
gnome-extensions enable caffeine@patapon.info

sleep 1

systemctl suspend -i
