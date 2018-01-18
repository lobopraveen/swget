#!/bin/bash
#
# swget - A simple wget downloader
#
# Copyright (C) 2010  Praveen Lobo(http://praveenlobo.com/blog/swget-a-simple-wget-wrapper/)
#
# Permission to use, copy, modify, and/or distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTUOUS ACTION, ARISING OUT OF
# OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

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
