#!/bin/bash

# Find all processes related to 'cs2', excluding the grep command itself
pids=$(ps aux | grep '[c]s2' | awk '{print $2}')

# Check if any PIDs were found
if [ -z "$pids" ]; then
  echo "No processes found related to cs2."
else
  # Kill each process
  echo "Killing the following processes:"
  echo "$pids"
  for pid in $pids; do
    sudo kill -9 $pid
  done
  echo "Processes killed."
fi

