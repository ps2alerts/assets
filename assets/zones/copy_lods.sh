#!/bin/bash
if [ $? -ne 3 ]; then
    echo "Usage: ./copy_lods.sh {lod0, lod1, lod2, lod3} <from-directory> <to-directory>"
    echo "    This script copies exported PS2 continent maps of various LODs to a tile map directory appropriate for each LOD"
    exit 1
fi
LOD=$1
directory=$2
outputdir=$3
if [ $LOD == "lod3" ]; then
    zoom=2
elif [ $LOD == "lod2" ]; then
    zoom=3
elif [ $LOD == "lod1" ]; then
    zoom=4
elif [ $LOD == "lod0" ]; then
    zoom=5
else
    echo "Invalid LOD '$LOD'"
    exit 1
fi
declare -i x
declare -i z
increment="$((2**(7-$zoom)))"
echo $increment

for file in $directory/$LOD/*
do 
    base="$(basename -- $file)";
    x="$(echo $base | cut -d_ -f3 | awk '$0*=1')";
    x="$((($x+64) / $increment))"
    z="$(echo $base | cut -d_ -f4 | awk '$0*=1')";
    z="$((($z*-1+64-$increment) / $increment))"
    magick $file -flip $outputdir/$zoom/tile_"$x"_"$z".png
done