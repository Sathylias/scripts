#!/bin/bash

# Code inspired by content found at http://v3gard.com/2011/01/getting-cmus-to-cooperate-with-conky/

if ps -C cmus > /dev/null; then

    artist=`cmus-remote -Q | 
	    grep --text '^tag artist' | 
	    sed '/^tag artistsort/d' | 
	    awk '{gsub("tag artist ", "");print}'`
    title=`cmus-remote -Q  | 
	    grep --text '^tag title' | 
	    sed -e 's/tag title //' |
	    awk '{gsub("tag title ", "");print}'`
    duration=`cmus-remote -Q | 
        grep --text '^duration' |
        awk '{print $2}'`
    position=`cmus-remote -Q |
        grep --text '^position' |
        awk '{print $2}'`

    sec=$(($duration % 60))
    min=$((($duration - $sec) / 60))
    [[ "$sec" -lt 10 ]] && sec="0$sec"
    time=$(echo $min:$sec)

    sec=$(($position % 60))
    min=$((($position - $sec) / 60))
    [[ "$sec" -lt 10 ]] && sec="0$sec"
    elapsed_time=$(echo $min:$sec)
    
    echo "$artist - $title $elapsed_time / $time";

fi
