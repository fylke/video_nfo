#!/bin/bash

IFS=$'\n'

function tokenize_filename {
	Title=${Filename}
    Artist=${Filename%\ -*}
    local TrackAndInfo=${Filename#*-\ }
    Track=${TrackAndInfo%\ \(*}
    local InfoAndParen=${TrackAndInfo#*\(}
    Info=${InfoAndParen%\)*}
}

function write_nfo_file {
	NfoFile=${VideoDir}\${Filename}.nfo
	echo "<musicvideo>" >> ${NfoFile}
	echo "    <title>${Title}</title>" >> ${NfoFile}
	echo "    <artist>${Artist}</artist>" >> ${NfoFile}
	echo "    <track>${Track}</track>" >> ${NfoFile}
	echo "    <album>${Album}</album>" >> ${NfoFile}
	echo "    <premiered>${Premiered}</premiered>" >> ${NfoFile}
	echo "    <director>${Director}</director>" >> ${NfoFile}
	echo "    <studio>${Studio}</studio>" >> ${NfoFile}
	echo "</musicvideo>" >> ${NfoFile}
}

function tokenize_info {
	Premiered=${Info#*,\ }
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

Files=$(find ${VideoDir} -type f -name "*.mp4")
for File in ${Files}; do
	Filenames+=$(basename ${File} .mp4)${IFS}
done

for Filename in ${Filenames}; do
	if [ ! -f ${Filename}.nfo ]; then
		tokenize_filename ${Filename}
		tokenize_info ${Info}
		write_nfo_file
	fi
done
