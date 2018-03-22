#!/bin/bash

NUM_RUNS=10000
NUM_NODES=10000
INIT_DEG=3
HEAL_THRES=70
DEAD_THRES=100
ALPHA=0
VERBOSE=0

while [ $ALPHA -le 1 ]
do
	RUN_NUM=1
	while [ $RUN_NUM -le NUM_RUNS ]
	do
		srun -N 1 -n 1 -p sched_mit_hil -t 00:01:00 ./resilience $NUM_NODES $INIT_DEG $HEAL_THRES $DEAD_THRES $ALPHA $ALPHA $VERBOSE > out.dat
		((RUN_NUM++))
	done
	ALPHA=$((ALPHA + 0.1))
done
