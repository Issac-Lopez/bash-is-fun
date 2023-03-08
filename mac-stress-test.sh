#!/bin/bash

# Make the script executable
chmod +x "$0"

# Function to stress the CPU
stress_cpu () {
  # Set the number of CPU cores to use
  cores=$(sysctl -n hw.ncpu)

  # Start the stress test
  echo "Stressing CPU..."
  stress --cpu $cores --timeout $1 &
}

# Function to stress the GPU
stress_gpu () {
  # Check if the Mac has a GPU
  if [ "$(system_profiler SPDisplaysDataType | grep 'Graphics/Displays:')" ]; then
    # Start the stress test
    echo "Stressing GPU..."
    stress --gpu --timeout $1 &
  else
    echo "No GPU detected"
  fi
}

# Function to stress the memory
stress_memory () {
  # Get the total memory size
  memory=$(sysctl -n hw.memsize)

  # Start the stress test
  echo "Stressing memory..."
  stress --vm 1 --vm-bytes $(($memory/4)) --timeout $1 &
}

# Get the user-specified duration for the stress tests
read -p "Enter the duration (in seconds) of the stress tests: " duration

# Get the user's choice of hardware component to stress test
read -p "Enter 'cpu', 'gpu', 'memory', or 'all' to specify the hardware component to stress test: " hardware

# Start the stress tests
if [ "$hardware" == "cpu" ]; then
  stress_cpu $duration
elif [ "$hardware" == "gpu" ]; then
  stress_gpu $duration
elif [ "$hardware" == "memory" ]; then
  stress_memory $duration
elif [ "$hardware" == "all" ]; then
  stress_cpu $duration
  stress_gpu $duration
  stress_memory $duration
else
  echo "Invalid input"
  exit 1
fi

# Wait for the stress tests to finish
wait

# Kill any processes associated with this script
kill $(pgrep -f $0)

# Print a message when the stress tests are done
echo "Stress tests completed"

