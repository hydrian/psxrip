#!/usr/bin/env bash
#
#  This is a script to create a .bin image with corresponding .cue out of your
#  PSX game discs as backup and/or for usage with emulators.
#
#  Run-time requirements: cdrdao
#
#  This script is partly based upon the "wesnoth-optipng" script from the
#  Battle for Wesnoth team.
#
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License version 2 or,
#  at your option any later version. This program is distributed in the
#  hope that it will be useful, but WITHOUT ANY WARRANTY.

CONFIG_FILE="${HOME}/.config/psxrip.conf"
PSXDIR="${HOME}/psxrip"
DRIVE="/dev/cdrom"
SUBCHAN=true
USE_RAW_DRIVER=false
SLOWRIP=true
UMOUNT=true
EJECT_ON_DONE=true

########################
### Support Function ###
########################

report_absent_tool()
{
	echo "$1 is not present in PATH. $(basename ${0}) requires it in order to work properly."
	if [ -n "$2" ]; then
		echo "You can obtain $1 at <${2}>."
	fi
	exit -1
}

print_help()
{
cat << EOSTREAM
Script for ripping PSX game discs into .bin files with corresponding .cue files.

Usage:
  $(basename ${0}) [{--outputdir} <value>] [{--drive} <value>] [--disable-subchan] [--use-raw-driver] [{--help|-h}] [--slow-rip] ][filename]

The parameter [filename] is mandatory. Without it, the script will abort. Plain
spaces in the filename are prohibited!

Available switches:
  --drive       Define the device to be used. If this parameter is not
                provided, /dev/cdrom will be used.

  --help / -h   Displays this help text.

  --disable-subchan  Don't extract subchannel data. Subchannel data might be
                     required for some PSX copy protection though it *could* create
                     problems. Retry with this parameter set if any problems occur
                     when trying to use the resulting image.

  --outputdir        Define the folder in which the resulting image should be saved.
                     If the folder does not exist, it will be created. If no
                     --outputdir parameter is given, the folder ~/psxrip will be
                     used.
  --enable-fast-rip  Runs CD-ROM reader at full speed to get a faster rip but lower 
                     quality 
  				     (Not Recommended)
  --use-raw-driver   Uses generic-mmc-raw instead of generic-mmc:0x20000 driver
                     (Not Recommended) Here for legacy reasons. 
  --disable-umount   Disables automatic unmount of mounted DRIVE if mount is detected. 
  --disable-eject    Disables CD-ROM eject on a successful rip
  
This tool requires cdrdao (http://cdrdao.sourceforge.net/) to be installed and
available in PATH.
EOSTREAM
}

### Get min CD-Rom read speed ###
function get-cdr-min-speed {
	 CDROM_MIN_SPEED=$(CDR_DEVICE=${DRIVE} wodim -prcap |egrep 'Current[[:space:]]+read[[:space:]]+'|sed -r 's/^.*CD[[:space:]]+([[:digit:]]+)x.*$/\1/')
	 echo $CDROM_MIN_SPEED
	 return 0
}
	



if [ -e "${HOME}/.config/psxrip" ] ; then
	source "${CONFIG_FILE}"
fi 

# go through provided parameters
while [ "${1}" != "" ]; do
	if [ "${1}" = "--drive" ]; then
		DRIVE=$2
		shift 2
	elif [ "${1}" = "--outputdir" ]; then
		PSXDIR=$2
		shift 2
	elif [ "${1}" = "--disable-subchan" ]; then
		SUBCHAN="false"
		shift 1
	elif [ "${1}" = "--help" ] || [ "${1}" = "-h" ]; then
		print_help
		exit 0
	elif [ "${1}" = "--enable-fast-rip" ] ; then
		SLOWRIP=false
		shift 1
	elif [ "${1}" = "--use-raw-driver" ] ; then
		USE_RAW_DRIVER=true
		shift 1
	elif [ "${1}" = "--disable-umount" ] ; then
		UMOUNT=false
		shift
	elif [ "${1}" = "--disable-eject" ] ; then
		EJECT_ON_DONE=false
		shift 1
	elif [ "${2}" != "" ] ; then
		echo "ERROR: Inval id usage. Displaying help:"
		echo ""
		print_help
		exit -1
	else
		IMAGENAME=$1
		shift
	fi
done

#input checking
if [ ! -e "${DRIVE}" ] ; then
	echo "Optical drive ${DRIVE} not found" 1>&2
	exit 2
fi  

# check for required dependencies
which cdrdao &> /dev/null ||
	report_absent_tool cdrdao 'http://cdrdao.sourceforge.net/'
	

# output recognized parameters
echo "Program "$(basename ${0})" called. The following parameters will be used for"
echo "creating an image of a PSX disc:"
echo "Folder for saving images: "$PSXDIR
echo "Drive used for reading the image: "$DRIVE
echo "Resulting filenames: "$PSXDIR"/"$IMAGENAME"[.bin|.cue]"
if [ "$NOSUBCHAN" = "true" ]; then
	echo "Not extracting subchan data."
else
	echo "Extracting subchan data."
fi
echo ""

# check if imagename is defined
if [ "$IMAGENAME" = "" ]; then
	echo "ERROR: Invalid usage. Found no name for resulting image. Displaying help:"
	echo ""
	print_help
	exit -1
fi

# create dir for resulting image if it does not exist yet
if ! [ -d "$PSXDIR" ]; then
	echo "outputdir not found, creating folder: "$PSXDIR
	echo ""
	mkdir -p $PSXDIR
	if [ $? -ne 0 ] ; then
		echo "Failed to create ${PSXDIR}" 1>&2
		exit 2
	fi
fi

# Check device mount status
mount|egrep --quiet "${DRIVE}\ on"
if [ $? -eq 0 ] ; then
	if ($UMOUNT) ; then
		umount "${DRIVE}"
		if [ $? -eq 0 ] ; then
			echo "Unmounted ${DRIVE}"
		else
			echo "Failed to unmount ${DRIVE}" 1>&2
			exit 2
		fi
	else 
		echo "${DRIVE} is mounted. Please unmount." 1>&2
		exit 2
	fi
fi
	

echo "starting ripping the disc"
echo ""
# final commandline for reading the disc and creating the image
if [ "$SUBCHAN" = "true" ]; then
	SUBCHANSTR='--read-subchan rw_raw'
fi


if ($SLOWRIP) ; then
	CDR_SPEED=2
	READ_SPEED_STR="--rspeed ${CDR_SPEED}"
	echo "Setting CD-ROM drive to slow speed (${CDR_SPEED}x) for ripping"
fi

if ($USE_RAW_DRIVER) ; then
	DRIVER="generic-mmc-raw"
else 
	DRIVER="generic-mmc:0x20000"	
fi

cdrdao read-cd -v 3 $READ_SPEED_STR --read-raw --datafile "$PSXDIR/$IMAGENAME.bin" --device "$DRIVE" --driver "$DRIVER" ${SUBCHANSTR} "$PSXDIR/$IMAGENAME.toc" 
if [ $? -ne 0 ] ; then
	echo "Failed to dump PSX image" 1>&2
	exit 2
fi

echo "Generating CUE file"
toc2cue "$PSXDIR/$IMAGENAME.toc" "$PSXDIR/$IMAGENAME.cue"
if [ $? -ne 0 ] ; then
	echo "Failed to convert toc to cue" 1>&2
	exit 2
fi
($EJECT_ON_DONE) && eject "${DRIVE}"
exit 0