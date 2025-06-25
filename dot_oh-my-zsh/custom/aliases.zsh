alias ls='eza --no-quotes'
alias ll='ls -l --icons always'
alias top='btop'
alias lal='ls -lAh'
alias dua='du -sh `ls -A | grep . | cut -d "'" "'" -f6-`'
alias v='nvim'
alias vim='nvim'
alias ide='nvim .'
alias ping="prettyping"
alias cat="bat -pp --color=always --theme=ansi"
alias less="bat -p --color=always --theme=ansi"
alias please='sudo $(fc -ln -1)'
alias colorpalette='for i in {0..255}; do print -Pn "%K{$i}  %k%F{$i}${(l:3::0:)i}%f " ${${(M)$((i%6)):#3}:+$'\n'}; done'

alias dc='docker compose'
alias drun='docker run --rm -ti --entrypoint sh'

# Mac OS X
if [ "$(uname -s)" = "Darwin" ]; then
    alias subl="/Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl -a -s"
    alias python="/usr/bin/python3"
    alias cp='\gcp'
    alias rm='\grm'
fi

# Linux
if [ "$(uname -s)" = "Linux" ]; then
  alias clearswap="su -c 'swapoff -a && swapon -a'"
  alias bat="batcat"
fi

function nexttag
{
    LEVEL=$1
    CURRENT_TAG=`git tag | sort -V | tail -1`
    if [[ $CURRENT_TAG = *"RC"* ]] && [[ -z $LEVEL ]]; then
        VERSION_PREFIX=$(sed -r 's/^(.+RC).+$/\1/' <<< $CURRENT_TAG)
        PRERELEASE_VERSION=$(sed -r 's/^.+RC([0-9]+)$/\1/' <<< $CURRENT_TAG)
        NEXT_PRERELEASE_VERSION=$(($PRERELEASE_VERSION+1))
        echo $VERSION_PREFIX$NEXT_PRERELEASE_VERSION
    else
        echo v$(semver -i $LEVEL $CURRENT_TAG)
    fi
}

function show_function
{
  declare -f "$1" | less
}

function meteo
{
    curl -4 "wttr.in/$1"
}

function replace_spaces_in_filenames
{
  for f in *\ *; do mv "$f" "${f// /$1}"; done
}

function vv
{
    [ -z "$1" ] && local FILE=$(fzf) || local FILE=$(cd "$1" && fzf)
    [ -z $FILE ] || vim $FILE
}

# Display file count and total size for files with specified extension
function total_ext {
  if [[ -z "$1" ]]; then
    echo -e "Usage:\n\t$0 <extension>"
    return 1
  fi
  
  # Find files, count them, and get total size
  file_count=$(find . -iname "*.$1" | wc -l)
  total_size=$(find . -iname "*.$1" -exec du -ch {} + | grep total)
  
  echo "File count: $file_count"
  echo "$total_size"
}

function ls_ext
{
  pattern="${1:-*}"

  # Get total size and file count for the directory
  total_size=$(du -sh . | awk '{print $1}')
  total_count=$(find . -type f | wc -l)
  
  # Print total size and count for the whole directory
  echo -e "Extension\t$total_count\t$total_size\t-"
  echo "---"
  
  # Loop through each file extension and print its count, size, and mean file size
  for extension in $(find . -type f -name "$pattern" | sed -n 's/.*\.\([a-zA-Z0-9]*\)$/\1/p' | sort | uniq; echo "<none>"); do
    if [ "$extension" = "<none>" ]; then
      # Handle files without an extension
      total=$(find . -type f ! -name "*.*" -name "$pattern" -exec du -ch {} + | grep total$ | awk '{print $1}')
      count=$(find . -type f ! -name "*.*" -name "$pattern" | wc -l)
      total_bytes=$(find . -type f ! -name "*.*" -exec stat -f%z {} + | awk '{s+=$1} END {print s}')
      echo $total
    else
      # Handle files with an extension
      total=$(find . -type f -name "$pattern.$extension" -exec du -ch {} + | grep total$ | awk '{print $1}')
      count=$(find . -type f -name "$pattern.$extension" | wc -l)
      
      # Use platform-specific stat command to get file size in bytes
      if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS/BSD stat
        total_bytes=$(find . -type f -name "$pattern.$extension" -exec stat -f%z {} + | awk '{s+=$1} END {print s}')
      else
        # GNU/Linux stat
        total_bytes=$(find . -type f -name "$pattern.$extension" -exec stat --format="%s" {} + | awk '{s+=$1} END {print s}')
      fi
    fi
    
    # Calculate the mean file size (if count > 0 to avoid division by zero)
    if [ $count -gt 0 ]; then
      mean_bytes=$((total_bytes / count))
    else
      continue
    fi
    
    # Convert mean bytes to human-readable format
    mean_size=$(numfmt --to=iec-i --suffix=B $mean_bytes)
    
    echo -e "$extension\t$count\t$total\t$mean_size"
  done | sort -hr -k3
}

