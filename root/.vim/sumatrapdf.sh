#!/bin/zsh
# This script is used to let the SumatraPDF open the pdf after path conversion

new_arg=()                 # ceate arguments array
declare -i idxMntOccur=0

for arg ($@) {
  if [[ "$arg" == /mnt* ]] {
    # convert to windows style path
    idxMntOccur=idxMntOccur+1
    winPath=$(wslpath -m $arg)
    new_arg+=$winPath

    if (($idxMntOccur == 1)) {
      # convert the path in .syntex to windows style
      # run only "/mnt/d" like path is detected
      find ${PWD} -maxdepth 1 -name "*.synctex.gz" -execdir \
        bash -c 'cat "{}" | gunzip | sed --expression="s@/mnt/\(.\)/@\1:/@g" | gzip > "{}.tmp" && mv "{}.tmp" "{}"' \;
    }
  } else {
    new_arg+=$arg
  }
}

$(SumatraPDF.exe $new_arg)
