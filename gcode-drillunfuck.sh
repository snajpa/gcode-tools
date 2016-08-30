#!/bin/bash

prevline=
skip=0

while read line; do
	if [[ $line =~ ^M05 ]]; then
		read nuline;
		if [[ $nuline =~ M02 ]]; then
			echo "( program end detect )"
			echo $line
			echo $nuline
			continue;
		fi
		for i in $(seq 1 7); do
			read $devnull;
		done
	else
		[[ $line =~ ^T ]] || echo $line
	fi
done
