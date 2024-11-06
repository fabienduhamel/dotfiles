function pic-init-sort {
    mkdir -p mp4 raw jpg

    IFS=$'\n'


    for file in $(\ls | grep -E \.'(MP4|mp4)'); do
        mv "$file" mp4/
    done

    for file in $(\ls | grep -E \.'(JPG|jpg)'); do
        RAW="${file%.*}.RW2"
        if [ -e "$RAW" ]; then
            mv "$file" raw/
            mv "$RAW" raw/
        else
            mv "$file" jpg/
        fi
    done
}

function pic-rm-orphan-raws
{
    mkdir -p delete
    for file in $(\ls RAW | grep .RW2); do JPG=${file%.*}.JPG; ls . | grep -E "^$JPG$" && echo "$JPG exists" || mv RAW/$file delete ; done
}

function pic-rm-orphan-jpegs
{
    mkdir -p delete
    for file in $(\ls . | grep .JPG); do
        RAW=${file%.*}.RW2;
        \ls . | grep -E "$RAW$" && echo "$RAW exists" || mv $file delete/
    done
}

function pic-normalize-filenames
{
  FILE_OR_DIR=${1:-.}
  exiftool '-FileName<${DateTimeOriginal}_${Model;s/ /-/g}%-c.%e' -d "%Y%m%d_%H%M%S" $FILE_OR_DIR
}

function pic-exif-cp {
  # Check if required arguments are provided
  if [[ $# -lt 3 ]]; then
      echo "Usage: $0 <directory> <source-pattern> <dest-pattern>"
      return 1
  fi

  # Set variables from arguments
  directory="${1}"
  source_pattern="$2"
  dest_pattern="$3"

  # Find and process each file in the directory
  for file in "$directory"/*; do
    filename=$(basename "$file")

    # Check if filename matches the source pattern
    if [[ "$filename" =~ $source_pattern ]]; then
      echo -e "Working on file $filename found..."

      # Replace source pattern with dest pattern in the filename to get the destination filename
      dest_file_name=$(echo "$filename" | sed -E "s/$source_pattern/$dest_pattern/")

      # Check if destination file exists
      if [[ ! -f "$directory/$dest_file_name" ]]; then
        echo -e "Dest file $dest_file_name not found. Skipping."
        continue
      fi

      echo -e "Dest file $dest_file_name found..."

      # Copy EXIF metadata from source file to destination file
      exiftool -TagsFromFile "$file" "$directory/$dest_file_name" -overwrite_original
      echo "EXIF data copied from $filename to $dest_file_name."

      # Copy timestamp from source file to destination file
      touch -r "$file" "$directory/$dest_file_name"
      echo "Timestamp copied from $filename to $dest_file_name."

      echo -e "Dest file $dest_file_name successfully processed."
    fi
  done
}
