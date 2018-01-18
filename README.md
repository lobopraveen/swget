# swget
swget - A simple wget downloader

Additional information and alternatives available at https://praveenlobo.com/blog/swget-a-simple-wget-wrapper/ 


## Specifications:

### Input : 
A file which contains the URLs of contents to be downloaded. One URL per line.

### Syntax:
`sh swget.sh URLFile` - this will not shutdown system after the download is complete.

`sudo sh swget.sh URLFile` - this will shutdown the system once the download is complete.

### Output:
Downloads the contents to the present working directory; it also creates a log file.

### Limitation:
Once started, the download continues until it is complete. It doesn't stop downloads at 8AM. If you have a large file you'd have to take care of stopping the download at 8AM.
Also, I'm not sure if the incomplete downloads are resumed. By default wget command resumes incomplete downloads but I have not tested it.

