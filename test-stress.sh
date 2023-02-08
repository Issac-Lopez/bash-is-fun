#!/bin/bash

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

# Function to calculate the CPU usage
calculate_cpu_usage () {
  # Get the total CPU usage
  total_cpu_usage=$(top -l 1 | awk '/CPU usage/ {print $3}')

  # Calculate the percentage of CPU usage
  cpu_usage_percentage=$(echo $total_cpu_usage | awk '{print 100 - $1}')

  # Output the CPU usage percentage
  echo "CPU Usage: $cpu_usage_percentage%"
}

# Function to calculate the memory usage
calculate_memory_usage () {
  # Get the total memory size
  total_memory=$(sysctl -n hw.memsize)

  # Get the used memory size
  used_memory=$(top -l 1 | awk '/PhysMem/ {print $2}')

  # Calculate the percentage of memory usage
  memory_usage_percentage=$(echo $used_memory $total_memory | awk '{printf "%.0f\n", ($1/$2)*100}')

  # Output the memory usage percentage
  echo "Memory Usage: $memory_usage_percentage%"
}

# Get the user-specified duration for the stress tests
read -p "Enter the duration (in seconds) of the stress tests: " duration

# Get the user-specified interval for the output
read -p "Enter the interval (in seconds) for output: " interval

# Get the user's choice of hardware component to stress test
read -p "Enter 'cpu', 'gpu', 'memory', or 'all' to specify the hardware component to stress test: " hardware

# Start the stress tests
if [ "$hardware" == "cpu" ]; then
  stress_cpu $duration &
elif [ "$hardware" == "gpu" ]; then
  stress_gpu $duration &
elif [ "$hardware" == "memory" ]; then
  stress_memory $duration &
elif [ "$hardware" == "all" ]; then
  stress_cpu $duration &
  stress_gpu $duration &
  stress_memory $duration &
else
  echo "Invalid input"
  exit 1
fi

wait

echo "Stress tests completed"
