# MP3-Combiner


## Description

This script will take an audiobook in the format of a directory full of mp3 files and convert it into a single mp3 file. It is multi-threaded and therefore able to take advantage of multiple cpus.



## Setup
You will need a BASH shell prompt. On Windows, you can use [Cygwin](https://www.cygwin.com/). Mac and Linux have a BASH shell natively.

Also, you will need to install [sox](http://sox.sourceforge.net/).



## Organizing your files
Set up your directories of MP3's with a parent directory and subdirectories of Audio Books.

like this:

    /MP3/
    /MP3/Example Audio Book/
    /MP3/Example Audio Book/Example Audio Book 1.mp3
    /MP3/Example Audio Book/Example Audio Book 2.mp3
    /MP3/Example Audio Book/Example Audio Book 3.mp3
    /MP3/Example Audio Book/Example Audio Book 4.mp3
    /MP3/Example Audio Book/Example Audio Book 5.mp3
    /MP3/Different Audio Book/
    /MP3/Different Audio Book/Different Audio Book 1x01.mp3
    /MP3/Different Audio Book/Different Audio Book 1x02.mp3
    /MP3/Different Audio Book/Different Audio Book 1x03.mp3
    /MP3/Different Audio Book/Different Audio Book 2x01.mp3
    /MP3/Different Audio Book/Different Audio Book 2x02.mp3
    /MP3/Different Audio Book/Different Audio Book 2x03.mp3



## Notes

This script assumes a few things:

- The directories that contain audio book mp3 files are named in a sorted order sequentially
- The directory of the audio book is named what you would like the output filename to be with a .mp3 appended to it (in the example above, the first audio book would be named ```/MP3/Example Audio Book.mp3```)
- If there is already a mp3 file in the present directory which matches a directory (minus the .mp3 extension), then it is assumed that the directory has already been combined, and it is therefore skipped. If this is incorrect, you will need to delete or rename the .mp3 file whose name matches the directory with the audio files you're trying to combine.
- If there is any failure during the process of combining mp3 files, the output file being created will be deleted. This happens for example when one or more of the audio book mp3 files are zero bytes (such as in the example above, ```/MP3/Different Audio Book/Different Audio Book 1x02.mp3``` is zero bytes).
- This script determines the number of CPU's you have and runs a combining job for all CPU's except for 1.  For example, if you have dual CPU's and they are each quad-core, then you have 8 logical CPU's.  This script would run 7 concurrent combining jobs leaving one CPU available to the user.



## Running

* Open your terminal (Cygwin on Windows)
* Change to the /MP3/ directory:
    `cd /MP3/`
* Run the Script with no arguments:
    `/path/to/mp3-combiner.sh`
* Wait for it to finish
