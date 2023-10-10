#!/bin/bash
#set -x

IFS=$'\n'

function tokenize_filename {
    Title=$(echo ${Filename} | tr _ ' ')
    Artist=${Title%\ -*}
    local TrackAndInfo=${Title#*-\ }
    Track=${TrackAndInfo%\ \(*}
    local InfoAndParen=${TrackAndInfo#*\(}
    Info=${InfoAndParen%\)*}
}

function write_nfo_file {
	NfoFile=${VideoDir}/${Filename}.nfo
	echo "<musicvideo>" >> ${NfoFile}
	echo "    <title>${Title}</title>" >> ${NfoFile}
	echo "    <artist>${Artist}</artist>" >> ${NfoFile}
	echo "    <track>${Track}</track>" >> ${NfoFile}
	echo "    <album>${Album}</album>" >> ${NfoFile}
	echo "    <premiered>${Premiered}</premiered>" >> ${NfoFile}
	echo "    <director>${Director}</director>" >> ${NfoFile}
	echo "    <studio>${Studio}</studio>" >> ${NfoFile}
    for Tag in ${Tags}; do
        echo "    <tag>${Tag}</tag>" >> ${NfoFile}
    done
	echo "</musicvideo>" >> ${NfoFile}
}

function tokenize_info {
    case ${Info} in
        *", "*)
	        Premiered=${Info#*,\ }
            ;&
        *"Live"*)
            Tags+="Live performance"${IFS}
            ;&
        *"Official"*)
            Tags+="Official video"${IFS}
            ;&
        *"Drumcam"*)
            Tags+="Drumcam"${IFS}
            ;;
        *)
            ;;
    esac
}

usage() { echo "Usage: $0 -d <video directory>" 1>&2; exit 1; }

while getopts ":d:" Flag; do
    case "${Flag}" in
        d)
            VideoDir=${OPTARG}
            if [ ! -d ${VideoDir} ]; then 
            	usage 
            fi
            ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))

Files=$(find ${VideoDir} -maxdepth 1 -type f -not -name "*.nfo")
for File in ${Files}; do
    Extension=${File##*.}
	Filenames+=$(basename ${File} .${Extension})${IFS}
done

for Filename in ${Filenames}; do
	if [ ! -f ${Filename}.nfo ]; then
		tokenize_filename ${Filename}
		tokenize_info ${Info}
		write_nfo_file
	fi
done
