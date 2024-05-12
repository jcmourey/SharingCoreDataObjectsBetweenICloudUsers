#!/bin/zsh

# Define an array with all the required icon sizes
declare -a iconSizes=(40 60 58 87 80 120 180 20 40 29 76 152 167 48 55 66 88 92 100 102 108 172 196 216 234 258)

# Loop through the array and use each size to resample the image
for size in "${iconSizes[@]}"
do
    sips --resampleWidth $size icon1024.png --out "icon${size}.png"
done