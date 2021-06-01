# psxrip.sh
Bash script to backup Playstation (PSX) games in Linux

Script for ripping PSX game discs into .bin files with corresponding .cue files.

> Usage:
>  psxrip.sh [{--outputdir} <value>] [{--drive} <value>] [{--no-subchan] [{--help|-h}] [filename]
>
> The parameter [filename] is mandatory. Without it, the script will abort. Plain
s paces in the filename are prohibited!
>
>Available switches:
>  --drive       Define the device to be used. If this parameter is not
>                provided, /dev/sr0 will be used.
>
>  --help / -h   Displays this help text.
>
>  --no-subchan  Don't extract subchannel data. Subchannel data might be
>                required for some PSX copy protection though it *could* create
>                problems. Retry with this parameter set if any problems occur
>                when trying to use the resulting image.
>
>  --outputdir   Define the folder in which the resulting image should be saved.
>                If the folder does not exist, it will be created. If no
>                --outputdir parameter is given, the folder ~/psxrip will be
>                used.
>  --slow-rip    Slows down CD-ROM reader to it minimum read speed to get a 
>                better quality rip. This slows ripping process. (Recommeneded)>

This tool requires cdrdao (http://cdrdao.sourceforge.net/) and wodim to be installed and
available in PATH.