#!/bin/sh

# Search for HiveOS tarball

find_INSTALL_FILE() {

if [ ! -f /tmp/result.txt ]
then
	touch /tmp/result.txt
	cd /home
	cd ..
	cd ..
	find . -name "*Hive*" >> /tmp/result.txt
fi

}


# Check if first char in tarball dir is a dot, then delete dot
# and set INSTALL_FILE as the

set_INSTALL_FILE() {

	FIRST_CHAR=$( grep ".tar.gz" /tmp/result.txt | cut -c 1 )
	echo "FIRST_CHAR equals ${FIRST_CHAR}"
	if [ $FIRST_CHAR == "." ]
	then
		echo "Replacing leading char in install file path"
		echo "Setting install file path"
		grep ".tar.gz" /tmp/result.txt | sed -r 's/^.{1}//' >> /tmp/result.txt
		INSTALL_FILE=$( tail -n 1 /tmp/result.txt )
	else
		echo "Setting install file path"
		grep ".tar.gz" /tmp/result.txt >> /tmp/result.txt
		INSTALL_FILE=$( tail -n 1 /tmp/result.txt )
	fi

	echo "INSTALL_FILE is: ${INSTALL_FILE}"

}


# Move install file to tmp directory for extraction

move_INSTALL_FILE() {

	if [ ! -d /tmp/HiveOS ]
	then
		mkdir /tmp/HiveOS
	fi
	cp ${INSTALL_FILE} /tmp/HiveOS
}



# Extract install file

extract_INSTALL_FILE() {

	cd /tmp/HiveOS/
	FILE_NAME=$( ls )
	INSTALL_FILE=$( echo ${FILE_NAME} )
	tar xvzf $INSTALL_FILE
}

# Extract fw.tar.gz which contains the runme.sh for install

extract_FW() {

	mkdir /tmp/HiveOS/fw
	if [ -f fw.tar.gz ]
	then
		mv /tmp/HiveOS/fw.tar.gz /tmp/HiveOS/fw/
		cd fw
		tar xvzf fw.tar.gz
	else
		echo "Error Code 42069: No fw.tar.gz found"
		exit 42069
	fi

}


# Run the runme.sh to install the HiveOS

runme_sh() {

	if [ -f "/tmp/HiveOS/fw/runme.sh" ]
	then

		./runme.sh

	else
		echo "runme.sh Not Found! Aborting installation"
		exit 1
	fi

}


# Main Routine

find_INSTALL_FILE
set_INSTALL_FILE
move_INSTALL_FILE
extract_INSTALL_FILE
extract_FW
runme_sh
#run stage2 runme.sh if required
sleep 3
echo "You may reboot your system now"
#commands to set FARM_HASH??
#maybe
