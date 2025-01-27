#!/bin/bash -e
#----------------------------------------------------------
#  Script: zlaunch.sh
#  Author: Michael Benjamin
#  LastEd: Jan 2024
#----------------------------------------------------------
#  Part 1: Set global var defaults
#----------------------------------------------------------
ME=`basename "$0"`
TIME_WARP=1
VERBOSE=""
FLOW_DOWN_ARGS=""

#----------------------------------------------------------
#  Part 2: Check for and handle command-line arguments
#----------------------------------------------------------
for ARGI; do
    if [ "${ARGI}" = "--help" -o "${ARGI}" = "-h" ]; then
	echo "$ME [SWITCHES] [time_warp]                      " 
	echo "  --help, -h      Show this help message               " 
        echo "  --verbose, -v   Enable verbose mode                  "
	echo "  --res, -r       Tell xlaunch to generate report      " 
	echo "  --send, -s      Tell xlaunch to gen and send report  " 
	echo "  --silent        Run silently, no iSay                " 
	exit 0;
    elif [ "${ARGI//[^0-9]/}" = "$ARGI" -a "$TIME_WARP" = 1 ]; then 
        TIME_WARP=$ARGI
    elif [ "${ARGI}" = "--verbose" -o "${ARGI}" = "-v" ]; then
	VERBOSE="--verbose"
    elif [ "${ARGI}" = "--res" -o "${ARGI}" = "-r" ]; then
        FLOW_DOWN_ARGS+="${ARGI} "
    elif [ "${ARGI}" = "--send" -o "${ARGI}" = "-s" ]; then
        FLOW_DOWN_ARGS+="${ARGI} "
    elif [ "${ARGI}" = "--silent" ]; then
        FLOW_DOWN_ARGS+="${ARGI} "
    else 
        echo "$ME Bad arg:" $ARGI "Exiting with code: 1"
        exit 1
    fi
done

if [ ${VERBOSE} = "" ]; then
    FLOW_DOWN_ARGS+=" --quiet "
fi

FLOW_DOWN_ARGS+="${TIME_WARP} --com=alpha "
echo "zlaunch.sh FLOW_DOWN_ARGS:[$FLOW_DOWN_ARGS]"

# ENC: Number of encounters in a headless mission
ENC=20

xlaunch.sh $FLOW_DOWN_ARGS --sep=10 --enc=$ENC --com=shoreside --nogui
xlaunch.sh $FLOW_DOWN_ARGS --sep=9  --enc=$ENC --com=shoreside --nogui
xlaunch.sh $FLOW_DOWN_ARGS --sep=8  --enc=$ENC --com=shoreside --nogui
xlaunch.sh $FLOW_DOWN_ARGS --sep=7  --enc=$ENC --com=shoreside --nogui
xlaunch.sh $FLOW_DOWN_ARGS --sep=6  --enc=$ENC --com=shoreside --nogui
xlaunch.sh $FLOW_DOWN_ARGS --sep=4  --enc=$ENC --com=shoreside --nogui

mhash_archive_grp.sh --send --dir=exp/obavoid $VERBOSE

exit

# Convert raw results, to a file with averages over all experiments
if [ -f "results.log" ]; then
    alogavg results.log > results.dat
fi

# Build a plot using matlab
if [ -f "results.dat" ]; then
    matlab plotx.m -nodisplay -nosplash -r "plotx(\"results.dat\", \"plot.png\")"
fi

