#!/bin/bash

# Function to display the elapsed time
display_time () {
  local T=$1
  local D=$((T/60/60/24))
  local H=$((T/60/60%24))
  local M=$((T/60%60))
  local S=$((T%60))
  printf "%d:%02d:%02d:%02d\n" $D $H $M $S
}

# Initialize variables
start_time=0
elapsed_time=0
status="stopped"

# Main loop to handle user input
while true; do
  # Print the current status and time
  printf "Status: %s\n" $status
  display_time $elapsed_time

  # Read the user's input
  read -p "Enter 'start', 'stop', 'reset', or 'quit': " input

  # Start the stopwatch
  if [ "$input" == "start" ]; then
    if [ "$status" == "stopped" ]; then
      status="running"
      start_time=$(date +%s)
    fi

  # Stop the stopwatch
  elif [ "$input" == "stop" ]; then
    if [ "$status" == "running" ]; then
      status="stopped"
      end_time=$(date +%s)
      elapsed_time=$((end_time-start_time+elapsed_time))
    fi

  # Reset the stopwatch
  elif [ "$input" == "reset" ]; then
    status="stopped"
    start_time=0
    elapsed_time=0

  # Quit the program
  elif [ "$input" == "quit" ]; then
    break

  # Invalid input
  else
    echo "Invalid input"
  fi
done

