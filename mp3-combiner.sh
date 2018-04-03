#!/bin/bash
# Note: This script requires "sox" to be installed
# Note: Built with assumption that no sox jobs are running when started

command -v sox &>/dev/null || {
  echo >&2 "Sox is not installed. Please install before continuing."
  exit 1
}

IFS=$'\n' dirs="$(/usr/bin/ls | cat | grep -v .mp3)"
let cpus=$(cat /proc/cpuinfo | grep processor | wc -l)-1
i=1
declare -a need_to_process
declare -a files_being_written_to
declare -a end
declare -a lastend

for dir in $dirs; do
  # If there's not an MP3 file
  if [[ -z "$(find . -name "$dir.mp3")" ]]; then
    # Add the directory to the array
    need_to_process+=("$dir")
  fi
done

# Main Loop
# While there are directories to process (without mp3 files)
while [[ ${#need_to_process[@]} -gt 0 ]]; do

  # Loop through directories to process
  for dir in "${need_to_process[@]}"; do
    # If counter is less than the number of cpus and a mp3 file does not exist
    if [[ $i -le $cpus ]]; then
      if [[ ! -f "$dir.mp3" ]]; then
        echo "Processing \"$dir\""
        sox "$dir/*.mp3" -b 64 -r 44100 -c 1 "$dir.mp3" 1>/dev/null 2>&1 &
        let i++
        files_being_written_to+=("$dir")
      fi
    fi
  done

  # Give some time for files appear on disk
  sleep 10

  # while loop through array of files being worked on
  l=0
  for dir in "${files_being_written_to[@]}"; do

    # Capture the last line of the mp3 file into an array
    end[$l]="$(tail -n1 "$dir.mp3" | cat -A | md5sum)"

    # If the file was not written to in the last 10 secs
    if [[ "${end[$l]}" == "${lastend[$l]}" ]]; then
      let i--

      # Unset the files_being_written_to array element for that dir
      j=0
      for file in "${files_being_written_to[@]}"; do
        if [[ "$file" == "$dir" ]]; then
          unset files_being_written_to[$j]
          files_being_written_to=("${files_being_written_to[@]}")
        fi
        let j++
      done

      # Unset the need_to_process array element for that dir
      k=0
      for dir2 in "${need_to_process[@]}"; do
        if [[ "$dir2" == "$dir" ]]; then
          unset need_to_process[$k]
          need_to_process=("${need_to_process[@]}")
        fi
        let k++
      done

    fi
    lastend[$l]="${end[$l]}"
    let l++
  done

done
