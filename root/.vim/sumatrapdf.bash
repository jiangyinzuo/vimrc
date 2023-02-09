#!/bin/bash
# This script is used to let the SumatraPDF open the pdf after path conversion

new_arg=()                 # ceate arguments array
idxMntOccur=0

for arg in "$@"
do
	if [[ "${arg}" == /mnt* ]]
	then
		# convert to windows style path
		idxMntOccur=$idxMntOccur+1
		winPath=$(wslpath -m $arg)
		new_arg+=($winPath)

		if [[ $idxMntOccur == 1 ]]
		then
			# convert the path in .syntex to windows style
			# run only "/mnt/d" like path is detected
			find ${PWD} -maxdepth 1 -name "*.synctex.gz" -execdir \
				bash -c 'cat "{}" | gunzip | sed --expression="s@/mnt/\(.\)/@\1:/@g" | gzip > "{}.tmp" && mv "{}.tmp" "{}"' \;
		fi
	else
		new_arg+=("$arg")
	fi
done
SumatraPDF.exe "${new_arg[@]}"
