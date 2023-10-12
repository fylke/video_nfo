#!/bin/bash
#set -x

IFS=$'\n'

function tokenize_filename {
    local FullName=$(echo ${Filename} | tr _ ' ')
    Artist=${FullName%%\ -*}
    Title=${FullName#*-\ }
    local InfoAndParen=${Title##*\(}
    Info=${InfoAndParen%\)*}
}

function write_nfo_file {
	NfoFile=${VideoDir}/${Filename}.nfo
	echo "<musicvideo>" >> ${NfoFile}
	echo "    <title>${Title}</title>" >> ${NfoFile}
	echo "    <artist>${Artist}</artist>" >> ${NfoFile}
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
    # Need to clear these for each file
    Tags=""
    Premiered=""
    if [[ ${Info} == *", "* ]]; then
	    Premiered=${Info#*,\ }
    fi
    if [[ ${Info} == *"Live"* ]]; then
        Tags+="Live performance"${IFS}
    fi
    if [[ ${Info} == *"Official"* ]]; then
        Tags+="Official video"${IFS}
    fi
    if [[ ${Info} == *"Promo"* ]]; then
        Tags+="Promo video"${IFS}
    fi
    if [[ ${Info} == *"Drumcam"* ]]; then
        Tags+="Drumcam"${IFS}
    fi
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
