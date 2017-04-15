#!/usr/bin/env bash

while :
do
	START_TIME=$SECONDS
	lltv frames --parallel
	lltv generate
	lltv upload
	ELAPSED_TIME=$(($SECONDS - $START_TIME))
	echo $ELAPSED_TIME
done