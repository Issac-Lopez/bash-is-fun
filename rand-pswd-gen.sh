#!/bin/bash

# Make the script executable
chmod +x "$0"

# Set the default password length
DEFAULT_LENGTH=12

# Get the password length from the command line argument
length=${1:-$DEFAULT_LENGTH}

# Define the characters to be used in the password
chars='!@#$%^&*()_+-=[]{};:,.<>?0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'

# Use /dev/urandom to generate a random string of the desired length
password=$(LC_ALL=C head /dev/urandom | tr -dc "$chars" | head -c "$length")

# Print the password to the screen
echo "$password"

