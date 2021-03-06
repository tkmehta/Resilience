#!/bin/bash

NUM_NODES=10000
INIT_DEG=5
HEAL_THRES=40
DEAD_THRES=65
ALPHA=0
VERBOSE=0

while true
do
	ALPHA=0
	while [ $ALPHA -le 10 ]
	do
		alpha=$(echo "scale=2;$ALPHA/10" | bc -l)
		srun -N 1 -n 1 -p sched_mit_hill -t 00:15:00 ./resilience $NUM_NODES $INIT_DEG $HEAL_THRES $DEAD_THRES $alpha $VERBOSE >> out10k.dat
		((ALPHA++))
	done
done
