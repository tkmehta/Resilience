#!/bin/bash

NUM_RUNS=1
NUM_NODES=1
K_VAL=1
ALPHA=0
FRACS=1
FAILED_PATH_WEIGHT=1

while [ $ALPHA -le 1 ]
do
	RUN_NUM=1
	while [ $RUN_NUM -le NUM_RUNS ]
	do
		./resilience $NUM_RUNS $NUM_NODE $K_VAL $ALPHA $FRACS $FAILED_PATH_WEIGHT
		((RUN_NUM++))
	done
	ALPHA=$((ALPHA + 0.1))
done
