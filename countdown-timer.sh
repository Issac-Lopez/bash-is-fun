#!/bin/bash

while true; do

  # Ask the user for the duration of the timer in hours, minutes, and seconds
  read -p "Enter duration in hours: " hours
  if ! [[ $hours =~ ^[0-9]+$ ]]; then
    echo "Invalid input. Please enter a number from 0 to 9."
    continue
  fi

  read -p "Enter duration in minutes: " minutes
  if ! [[ $hours =~ ^[0-9]+$ ]]; then
    echo "Invalid input. Please enter a number from 0 to 9."
    continue
  fi
  
  read -p "Enter duration in seconds: " seconds
  if ! [[ $hours =~ ^[0-9]+$ ]]; then
    echo "Invalid input. Please enter a number from 0 to 9."
    continue
  fi

  # Calculate the  duration in seconds
  duration=$((hours * 3600 + minutes * 60 + seconds))

  # Set the interval in seconds for displaying the countdown
  interval=1

  # Calculate the end time
  end_time=$(($(date +%s) + $duration))
  
  # Display the countdown
  for (( i=$duration; i>=0; i--)); do
    printf "\r%02d:%02d:%02d" $((i/3600)) $((i%3600/60)) $((i%60))
    # Display the progress bar
    bar_length=50
    done_bar=$((i*bar_length/$duration))
    to_do_bar=$((bar_length-done_bar))
    printf "["
    for ((j=0; j<done_bar; j++)); do
        printf "#"
    done
    for ((j=0; j<to_do_bar; j++)); do
        printf "-"
    done
    printf "]"
    sleep 1
  done

  # Make beep sound when the timer finishes
  for i in {1..10}; do
    printf "\a"
    sleep 0.2
  done

  # Display a message when the timer finishes
  printf "Timer finished!\n"

  # Ask the user if they would like to end the script
  read -p "Would you like to set a timer again (y/n)? " end_script
  if [ "$end_script" == "n" ]; then
    break
  fi

done
