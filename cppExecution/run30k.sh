#!/bin/bash

NUM_NODES=30000
INIT_DEG=5
HEAL_THRES=40
DEAD_THRES=65
ALPHA=8
VERBOSE=0

while true
do
	alpha=$(echo "scale=2;$ALPHA/10" | bc -l)
	srun -N 1 -n 1 --exclusive -p sched_mit_hill -t 02:00:00 ./resilience $NUM_NODES $INIT_DEG $HEAL_THRES $DEAD_THRES $alpha $VERBOSE >> out30k.dat
done
