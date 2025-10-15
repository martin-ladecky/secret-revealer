#!/bin/bash

# Check if an argument was provided
if [ -z "$1" ]; then
  echo "Usage: $0 <string>"
  exit 1
fi

# The input string
input_string="$1"

# The output string
output_string=""

# Iterate through each character of the input string
for (( i=0; i<${#input_string}; i++ )); do
  char=${input_string:$i:1}
  
  # Convert the character to its ASCII value
  char_code=$(printf '%d' "'$char")
  
  # Check if the character is a lowercase letter
  if [[ "$char" =~ [a-z] ]]; then
    # Shift the character's ASCII value by 1
    shifted_code=$((char_code + 1))
    
    # Wrap around from 'z' to 'a'
    if [ "$shifted_code" -gt 122 ]; then
      shifted_code=97 # ASCII for 'a'
    fi
  # Check if the character is an uppercase letter
  elif [[ "$char" =~ [A-Z] ]]; then
    # Shift the character's ASCII value by 1
    shifted_code=$((char_code + 1))
    
    # Wrap around from 'Z' to 'A'
    if [ "$shifted_code" -gt 90 ]; then
      shifted_code=65 # ASCII for 'A'
    fi
  else
    # If it's not a letter, keep the character as is
    shifted_code=$char_code
  fi
  
  # Convert the shifted ASCII value back to a character
  shifted_char=$(printf "\x$(printf %x $shifted_code)")
  
  # Append the shifted character to the output string
  output_string+="$shifted_char"
done

# Print the final result
echo "$output_string"
