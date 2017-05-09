#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Parameters: <min x> <max x> <min y> <max y>"
    exit
fi

X_FROM=$1
X_TO=$2
Y_FROM=$3
Y_TO=$4

Z_SAFE=3
DEPTH=1.8
PASSES=1
BRIDGE_SIZE=0.2
TOOL_R=1.5875
FEEDRATE=100
SPINDLESPEED=24000

c() {
	echo "scale=4; $*" | bc
}


echo "( Made by snajpa's bash madness )"
echo G90
echo F$FEEDRATE
echo S$SPINDLESPEED
echo G00 Z$Z_SAFE
echo G00 X$X_FROM Y$Y_FROM
echo M03 
echo G04 P10.000000
echo G01 Z0

XBRSTART=$(c "( ($X_TO - $X_FROM) / 2 ) - ( $BRIDGE_SIZE / 2 ) - $TOOL_R + $X_FROM")
XBREND=$(c   "( ($X_TO - $X_FROM) / 2 ) + ( $BRIDGE_SIZE / 2 ) + $TOOL_R + $X_FROM")
YBRSTART=$(c "( ($Y_TO - $Y_FROM) / 2 ) - ( $BRIDGE_SIZE / 2 ) - $TOOL_R + $Y_FROM")
YBREND=$(c   "( ($Y_TO - $Y_FROM) / 2 ) + ( $BRIDGE_SIZE / 2 ) + $TOOL_R + $Y_FROM")

ZDOWN=$(c "$DEPTH / $PASSES")

for pass in $(seq 1 $PASSES); do
	ZNOW=$(c "0.0 - ($ZDOWN * $pass)")
	echo G01 Z$ZNOW

	echo G01 X$XBRSTART
	echo G00 Z$Z_SAFE
	echo G00 X$XBREND
	echo G01 Z$ZNOW
	echo G01 X$X_TO Y$Y_FROM

	echo G01 Y$YBRSTART
	echo G00 Z$Z_SAFE
	echo G00 Y$YBREND
	echo G01 Z$ZNOW
	echo G01 X$X_TO Y$Y_TO

	echo G01 X$XBREND
	echo G00 Z$Z_SAFE
	echo G00 X$XBRSTART
	echo G01 Z$ZNOW
	echo G01 X$X_FROM Y$Y_TO

	echo G01 Y$YBREND
	echo G00 Z$Z_SAFE
	echo G00 Y$YBRSTART
	echo G01 Z$ZNOW
	echo G01 X$X_FROM Y$Y_FROM
done

echo G00 Z$Z_SAFE
echo M05
echo M02
