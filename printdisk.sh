#!/usr/bin/bash

df -h | grep '/home' | awk '{print $4,"/",$2}' | tr -d ' '


