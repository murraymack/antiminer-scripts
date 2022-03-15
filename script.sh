#!/bin/bash

HOSTNAME=$(hostname)

function touch_test() {
	echo "Hello world to ${HOSTNAME}" > /home/Hello_World.txt
}

touch_test
