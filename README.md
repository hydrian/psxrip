# psxrip.sh
Bash script to backup Playstation (PSX) games in Linux

Script for ripping PSX game discs into .bin files with corresponding .cue files.

> Usage:
>  psxrip.sh [{--outputdir} <value>] [{--drive} <value>] [{--no-subchan] [{--help|-h}] [--slow-rip] [--use-raw-driver] FILENAME
>
> The parameter FILENAME is mandatory. Without it, the script will abort. Plain
s paces in the filename are prohibited!
>
>Available switches:
>  --drive       	Define the device to be used. If this parameter is not
>                	provided, /dev/sr0 will be used.
>
>  --help / -h   	Displays this help text.
>
>  --no-subchan  	Don't extract subchannel data. Subchannel data might be
>                	required for some PSX copy protection though it *could* create
>                	problems. Retry with this parameter set if any problems occur
>                	when trying to use the resulting image.
>
>  --outputdir   	Define the folder in which the resulting image should be saved.
>                	If the folder does not exist, it will be created. If no
>                	--outputdir parameter is given, the folder ~/psxrip will be
>                	used.
>
>  --slow-rip    	Slows down CD-ROM reader to 2x to get a better quality rip. This slows ripping process. (Recommended)
>
>  --use-raw-driver Uses generic-mmc-raw instead of generic-mmc:0x20000 driver (not-recommended) Here for legacy reasons.

This tool are required to be installed and available in PATH.
 * cdrdao (http://cdrdao.sourceforge.net/) 
## Installation
 1. Download psxrip.sh to machine with CD/DVD drive
 1. chmod +x psxrip.sh
 1. ./psxrip.sh PARAMETERS ... or put psxrip.sh in your $PATH
