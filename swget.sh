#!/bin/bash
#
# swget - A simple wget downloader
#
# MIT License
#
# Copyright (c) 2018 Praveen Lobo (praveenlobo.com)
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#

LOG=`pwd`"/$0.log"

echo "Simple wget downloader by Praveen Lobo(Lobo@PraveenLobo.com)" | tee $LOG
echo "More information at http://praveenlobo.com/blog/swget-a-simple-wget-wrapper/ " | tee -a $LOG
echo "Log - $LOG"

if [ $# -ne 1 ]; then
 echo "Usage: $0 [FILENAME]"
 exit 101
fi

filename=$1

if [ ! -e $1 -o ! -s $1 ]; then
 echo "File:$1 does not exist or is 0-byte file!"
 exit 101
fi

# Get current hour, minute and milliseconds since epoch
hhmmS=`date "+%H:%M:%s"`
hh=`echo $hhmmS | cut -d":" -f1`
mm=`echo $hhmmS | cut -d":" -f2`
secondsNow=`echo $hhmmS | cut -d":" -f3`

# Get milliseconds since epoch at 2:05AM 'today'
dt="`date +%m/%d/%Y` 02:05 AM"
secondsAtTwo5=`date --date "$dt" +%s`

if [ $hh -gt 6 ]; then
 # It's already past 6:59AM; Get milliseconds since epoch at next 2:05AM
 secondsAtTwo5=`expr $secondsAtTwo5 + 86400`
fi

# Get difference between now and next 2:05AM
gap=`expr $secondsAtTwo5 - $secondsNow`

if [ $gap -gt 0 ]; then
 # Sleep until next 2:05AM
 echo "`date "+%m/%d/%Y %H:%M:%S"` Sleeping for $gap seconds..." | tee -a $LOG
 sleep $gap
fi

echo "`date "+%m/%d/%Y %H:%M:%S"` Starting download..." | tee -a $LOG

# Start dowloading the contents mentioned in the file; Give 10 seconds gap between each download
# Remove -nv option to get a detailed log
wget -nc -nv --progress=bar:force -w 10  -i $1 -a $LOG

echo "`date "+%m/%d/%Y %H:%M:%S"` Download complete..." | tee -a $LOG

# Running this script as root will shutdown the system;
halt
