# psxrip.sh
Bash script to backup Playstation (PSX) games in Linux

Script for ripping PSX game discs into .bin files with corresponding .cue files.

> Usage:
>  psxrip.sh [{--outputdir} <value>] [{--drive} <value>] [{--no-subchan] [{--help|-h}] [--enable-fast-rip] [--use-raw-driver] FILENAME
>
> The parameter FILENAME is mandatory. Without it, the script will abort. Plain
s paces in the filename are prohibited!
>
>Available switches:
>  --drive       		Define the device to be used. If this parameter is not
>                		provided, /dev/cdrom will be used.
>
>  --help / -h   		Displays this help text.
>
>  --disable-subchan  	Don't extract subchannel data. Subchannel data might be
>                		required for some PSX copy protection though it *could* create
>                		problems. Retry with this parameter set if any problems occur
>                		when trying to use the resulting image.
>
>  --outputdir   		Define the folder in which the resulting image should be saved.
>                		If the folder does not exist, it will be created. If no
>                		--outputdir parameter is given, the folder ~/psxrip will be
>                		used.
>
>  --enable-fast-rip    Runs CD-ROM reader at full speed to get a faster rip but lower 
>						quality 
>						(Not Recommended)
>
>  --disable-umount		Disables automatic unmount of mounted DRIVE if mount is detected. 
>
>  --use-raw-driver 	Uses generic-mmc-raw instead of generic-mmc:0x20000 driver (not-recommended) Here for legacy reasons.
>
>  --disable-eject      Disables CD-ROM eject on a successful rip

This tool are required to be installed and available in PATH.
 * cdrdao (http://cdrdao.sourceforge.net/) 

## Installation
 1. Download psxrip.sh to machine with CD/DVD drive
 1. chmod +x psxrip.sh
 1. ./psxrip.sh PARAMETERS ... or put psxrip.sh in your $PATH

## Configuration
 1. Copy psxrip.example.conf to $HOME/.config/psxrip.conf
 1. chmod o+rw $HOME/.config/psxrip.conf
 1. Edit file for your specific needs

## Images tested with
  * ePSXe 2.0.5 (64-bit)
  