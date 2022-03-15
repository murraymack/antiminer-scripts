#!/bin/sh

getMinerInfo() {

/sbin/ifconfig | grep "inet addr:192." | awk 'NR==1 { print $2 }' | cut -c 6- > /tmp/myinfo
/sbin/ifconfig | grep "HWaddr" | awk 'NR==1 { print $5 }' >> /tmp/myinfo
if [[ ! -f /usr/bin/compile_time ]]
	then
	echo "BraiinsOS?" >> /tmp/myinfo
else
	sed -n 2p /usr/bin/compile_time | sed 's/[[:space:]]//g' >> /tmp/myinfo
fi
sed ':a;N;$!ba;s/\n/ /g' /tmp/myinfo > /tmp/minerinfo
rm /tmp/myinfo
cat /tmp/minerinfo

}

getMinerInfo
