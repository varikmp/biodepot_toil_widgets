#!/bin/bash

RED='\033[0;31m'
NORMAL='\033[0m'
CYAN='\033[1;36m'   

function help()
{
	echo -e "Usage: $1 ${RED}BIODEPOT_BWB_DIR${NORMAL} [install|remove|build|launch]"
	echo -e " - ${CYAN}install${NORMAL}: to install the Toil widget into BWB"
	echo -e " - ${CYAN}remove${NORMAL}: to remove the Toil widget from BWB"
	echo -e " - ${CYAN}build${NORMAL}: to build/update the BWB container image"
	echo -e " - ${CYAN}launch${NORMAL}: to launch BWB"
}

function refresh_list()
{
	# back up the current setup.py file
	mv $2/setup.py "$2/setup.py.$(date +"%Y%m%d_%H%M%S")"
	echo "from setuptools import setup" > $2/setup.py
	
	for directory in `ls $1`
	do
		echo "setup(name=\"$directory\",packages=[\"$directory\"],package_data={\"$directory\": [\"icons/*.svg\"]},entry_points={\"orange.widgets\": \"$directory = $directory\"},)" >> $2/setup.py
	done
}

if [ -z $1 ] || [ -z $2 ]
then
	help $0
	exit 0
fi

BIODEPOT_BWB=$1
OPERATION=$2

# check if the BioDepot BWB is a directory or right one
if [ ! -d "$BIODEPOT_BWB" ]
then
	echo -e "Could NOT find directory ${RED}$BIODEPOT_BWB${NORMAL}"
	exit 0
fi

if [ ! -d "$BIODEPOT_BWB/biodepot" ]
then
	echo -e "${RED}$BIODEPOT_BWB${NORMAL} is NOT biodepot/bwb directory"
	exit 0
fi

# work on the operation
if [ "$OPERATION" == "install" ]
then
	if [ -d "$BIODEPOT_BWB/biodepot/Toil" ]
	then
		echo -e "Toil is ${CYAN}already installed${NORMAL} in $BIODEPOT_BWB"
		exit 0
	fi

	cp -r biodepot "$BIODEPOT_BWB"
	cp -r widgets "$BIODEPOT_BWB"
	cp -r icons "$BIODEPOT_BWB"

	cd "$BIODEPOT_BWB"/biodepot/Toil
	ln -sf ../../widgets/Toil/Toil_CWL/Toil_CWL.py OWToilCWL.py
	ln -sf ../../widgets/Toil/Toil_WDL/Toil_WDL.py OWToilWDL.py
	ln -sf ../../widgets/Toil/Toil/Toil.py OWToilPython.py
	ln -sf ../../icons/ icons
	
	refresh_list "$BIODEPOT_BWB/widgets" "$BIODEPOT_BWB/biodepot"
	echo -e "Successfully ${CYAN}installed${NORMAL} the Toil widget plugin to the BWB"
elif [ "$OPERATION" == "remove" ] 
then
	if [ ! -d "$BIODEPOT_BWB/widgets/Toil" ] || [ ! -d "$BIODEPOT_BWB/biodepot/Toil" ] || [ ! -d "$BIODEPOT_BWB/biodepot/Toil.egg-info" ]
	then
		echo -e "Could not find ${RED}Toil${NORMAL} in $BIODEPOT_BWB"
		exit 0
	fi

	rm -rf "$BIODEPOT_BWB/widgets/Toil" > /dev/null
	rm -rf "$BIODEPOT_BWB/biodepot/Toil" > /dev/null
	rm -rf "$BIODEPOT_BWB/biodepot/Toil.egg-info" > /dev/null
	
	refresh_list "$BIODEPOT_BWB/widgets" "$BIODEPOT_BWB/biodepot"
	echo -e "Successfully ${CYAN}removed${NORMAL} the Toil widget plugin to the BWB"
elif [ "$OPERATION" == "build" ] 
then
	cd "$BIODEPOT_BWB"
	sudo docker build -t bwb-dev .
elif [ "$OPERATION" == "launch" ] 
then
	cd "$BIODEPOT_BWB"
	sudo docker run -d --rm -p 6080:6080 -v ${BIODEPOT_BWB}/:/data -v  /var/run/docker.sock:/var/run/docker.sock -v /home/varikmp/tmp:/tmp -v /tmp/.X11-unix:/tmp/.X11-unix --privileged --group-add root bwb-dev
else
	echo "The script did not recognize the operation '$2'"
	help $0
	exit
fi
