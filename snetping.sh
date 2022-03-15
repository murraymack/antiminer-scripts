#!/usr/bin/env bash

#Usage ./snetping.sh myiplist.txt output.txt
#      ./snetping.sh <your IPs> <your output>

if [[ ${#1} -eq 0 && ${#2} -eq 0 ]]
	then
		echo "Error40! Please designate target IP list and your output file!"
		echo "Such as:     ./snetping.sh myIPs.txt myOutput.txt"
	exit 40
fi

if [[ ${#1} -gt 0 && ${#2} -eq 0 ]]
	then
		echo "Error41! Please designate a target output file!"
		echo "Such as:     ./snetping.sh myIPs.txt myOutput.txt"
	exit 41
fi

pwd=$( pwd )
targetlist="${pwd}/${1}"
outputlist="${pwd}/${2}"

check_input() {
	if [[ $( wc -l < ${targetlist} ) -lt 1 ]]
	then
		echo "Error42! Please check contents of IP list!"
		echo "Example: $ cat myiplist.txt"
		echo "$ 192.168.1.2"
		echo "$ 192.168.1.3"
		echo "$ 192.168.1.254"
	exit 42
	fi
}

ping_n_save() {
	dpkg-query -W fping &> /dev/null
	if [ $? -ne 0 ]
	then
		echo "Error43! Please install fping using 'sudo apt-get update' and 'sudo apt-get install fping'"
	exit 43
	fi

	echo "Executing ping on ${targetlist} ..."
	fping -f ${targetlist} -C 3 &> /dev/null
	wait
	fping -f ${targetlist} 1> ${pwd}/tmpout 2> /dev/null
	wait
}

grepawk_alive() {
	grep "alive" ${pwd}/tmpout | awk '{ print $1 }' > ${outputlist}
}


preview() {
	if [[ $( wc -l < ${outputlist} ) -gt 4 ]]
	then
		head -3 ${outputlist}
		echo "..."
		tail -3 ${outputlist}
		echo "Total of $( wc -l < ${outputlist} ) IPs alive"
	else
		cat ${outputlist}
		echo "Total of $( wc -l < ${outputlist} ) IPs alive"
	fi
}


ping_n_save
grepawk_alive
rm tmpout
echo "Successfully saved live IPs to ${outputlist}"
echo "Previewing ${outputlist} ..."
preview
