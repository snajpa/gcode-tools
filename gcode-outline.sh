#!/bin/bash

X_EDGE=$1
Y_EDGE=$2
Z_SAFE=3
DEPTH=1.7
PASSES=5
BRIDGE_SIZE=0.2
TOOL_DIA=1.5875
FEEDRATE=100
SPINDLESPEED=24000

c() {
	echo "scale=4; $*" | bc
}

CORNER=$(c 0.0 - $TOOL_DIA)

echo "( Made by snajpa's bash madness )"
echo G90
echo F$FEEDRATE
echo S$SPINDLESPEED
echo G00 Z$Z_SAFE
echo G00 X$CORNER Y$CORNER
echo M03 
echo G04 P10.000000
echo G01 Z0

XMAX=$(c "$X_EDGE + $TOOL_DIA")
YMAX=$(c "$Y_EDGE + $TOOL_DIA")

XBRSTART=$(c "( $X_EDGE / 2 ) - ( $BRIDGE_SIZE / 2 ) - $TOOL_DIA")
XBREND=$(c   "( $X_EDGE / 2 ) + ( $BRIDGE_SIZE / 2 ) + $TOOL_DIA")
YBRSTART=$(c "( $Y_EDGE / 2 ) - ( $BRIDGE_SIZE / 2 ) - $TOOL_DIA")
YBREND=$(c   "( $Y_EDGE / 2 ) + ( $BRIDGE_SIZE / 2 ) + $TOOL_DIA")

ZDOWN=$(c "$DEPTH / $PASSES")

for pass in $(seq 1 $PASSES); do
	ZNOW=$(c "0.0 - ($ZDOWN * $pass)")
	echo G01 Z$ZNOW

	echo G01 X$XBRSTART
	echo G00 Z$Z_SAFE
	echo G00 X$XBREND
	echo G01 Z$ZNOW
	echo G01 X$XMAX Y$CORNER

	echo G01 Y$YBRSTART
	echo G00 Z$Z_SAFE
	echo G00 Y$YBREND
	echo G01 Z$ZNOW
	echo G01 X$XMAX Y$YMAX

	echo G01 X$XBREND
	echo G00 Z$Z_SAFE
	echo G00 X$XBRSTART
	echo G01 Z$ZNOW
	echo G01 X$CORNER Y$YMAX

	echo G01 Y$YBREND
	echo G00 Z$Z_SAFE
	echo G00 Y$YBRSTART
	echo G01 Z$ZNOW
	echo G01 X$CORNER Y$CORNER
done

echo G00 Z$Z_SAFE
echo M05
echo M02
