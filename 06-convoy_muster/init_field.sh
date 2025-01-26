#!/bin/bash 
#------------------------------------------------------------
#   Script: init_field.sh
#   Author: M.Benjamin
#   LastEd: Jan 24 2025
#------------------------------------------------------------
#  Part 1: A convenience function for producing terminal
#          debugging/status output depending on verbosity.
#------------------------------------------------------------
vecho() { if [ "$VERBOSE" != "" ]; then echo "$ME: $1"; fi }

#------------------------------------------------------------
#  Part 2: Set global variable default values
#------------------------------------------------------------
ME=`basename "$0"`
VEHICLE_AMT="1"
VERBOSE=""
RAND_VPOS="no"

#------------------------------------------------------------
#  Part 3: Check for and handle command-line arguments
#------------------------------------------------------------
for ARGI; do
    CMD_ARGS+=" ${ARGI}"
    if [ "${ARGI}" = "--help" -o "${ARGI}" = "-h" ]; then
	echo "$ME [OPTIONS] [time_warp]                      "
	echo "                                               "
	echo "Options:                                       "
	echo "  --amt=N            Num vehicles to launch    "
	echo "  --verbose, -v      Verbose, confirm values   "
	echo "  --rand, -r         Rand vehicle positions    "
	echo "                                               "
       exit 0;
    elif [ "${ARGI:0:6}" = "--amt=" ]; then
        VEHICLE_AMT="${ARGI#--amt=*}"
    elif [ "${ARGI}" = "--verbose" -o "${ARGI}" = "-v" ]; then
	VERBOSE=$ARGI
    elif [ "${ARGI}" = "--rand" -o "${ARGI}" = "-r" ]; then
        RAND_VPOS="yes"

    else 
	echo "$ME: Bad Arg: $ARGI. Exit Code 1."
	exit 1
    fi
done

#------------------------------------------------------------
#  Part 4: Source local coordinate grid if it exits
#------------------------------------------------------------

echo VEHICLE_AMT=$VEHICLE_AMT
echo LEGS=$LEGS

#------------------------------------------------------------
#  Part 5: Set starting positions, speeds, vnames, colors
#------------------------------------------------------------
echo VEHICLE_AMT=$VEHICLE_AMT
pickpos --poly="-2,-2 : 5,-22 : 81,11 : 74,33 "  \
        --amt=$VEHICLE_AMT --hdg=75,-100,0 > vpositions.txt

if [[ ! -f "vpositions.txt" ]]; then
    echo "Missing vpositions.txt file. Exiting."
    exit 1
fi

if [ "${RAND_VPOS}" = "yes" -o  ! -f "vspeeds.txt" ]; then
    pickpos --amt=$VEHICLE_AMT --spd=2:3 > vspeeds.txt
fi

pickpos --amt=$VEHICLE_AMT --vnames > vnames.txt
pickpos --amt=$VEHICLE_AMT --colors > vcolors.txt


#------------------------------------------------------------
#  Part 6: Set other aspects of the field, e.g., obstacles
#------------------------------------------------------------

#------------------------------------------------------------
#  Part 7: If verbose, show file contents
#------------------------------------------------------------
if [ "${VERBOSE}" != "" ]; then
    echo "--------------------------------------"
    echo "VEHICLE_AMT = $VEHICLE_AMT "
    echo "RAND_VPOS   = $RAND_VPOS   "
    echo "--------------------------------------(pos/spd)"
    echo "vpositions.txt:"; cat  vpositions.txt
    echo -n "Hit any key to continue"
    read ANSWER
fi

exit 0

