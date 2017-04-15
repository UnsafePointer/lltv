#!/usr/bin/env bash

while :
do
	START_TIME=$SECONDS
	bundle exec lltv frames --parallel
	bundle exec lltv generate
	bundle exec lltv upload
	ELAPSED_TIME=$(($SECONDS - $START_TIME))
	echo $ELAPSED_TIME
done
