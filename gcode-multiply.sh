#!/bin/bash


dos2unix $1

ADD_X=$2
ADD_Y=$3
PLACE_XTIMES=${4:-0}
PLACE_YTIMES=${5:-0}

for x in $(seq 0 $PLACE_XTIMES); do
	for y in $(seq 0 $PLACE_YTIMES); do

RUNADD_X=$(($ADD_X * $x))
RUNADD_Y=$(($ADD_Y * $y))

# Here be dragons

echo "run x $x y $y" 1>&2
cat $1 | while read line; do
	set $line
	ignore=true
	for i in $(seq 1 $#); do
		if [[ ${!i} =~ M0?2$ ]]; then
			param="( ${!i} )"
		else
			param=${!i}
		fi
		firstchar=${param:0:1}
		case "$firstchar" in
		X | Y )
			value=${param:1}
			echo -en $firstchar
			addvar="RUNADD_${firstchar}"
			echo -en $(echo "scale=4; $value + ${!addvar}" | bc)
			;;	
		*)
			echo -en $param
			;;
		esac
		echo -en " "
	done;
	echo
done

done
done

echo "( Settings: )"
echo "( Original file: $1 )"
echo "( ADD_X = $ADD_X )"
echo "( ADD_Y = $ADD_Y )"
echo "( PLACE_XTIMES = $PLACE_XTIMES)"
echo "( PLACE_YTIMES = $PLACE_YTIMES)"
echo M02
