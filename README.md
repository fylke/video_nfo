# video_nfo

Generate Kodi-style music video `.nfo` metadata files from music video filenames. It assumes that you have named the files according to the correct conventions already.

## What It Does

The script scans a target directory for video files and creates one `.nfo` file per video.

- Input: files in a directory you pass with `-d`
- Output: generated `.nfo` files in `<video-directory>/.output/`
- Existing output files are not overwritten

## Filename Format

The parser expects names in this format:

`Artist_-_Title_(Info)`

Use underscores (`_`) for spaces in filenames.

Example:

`A_Perfect_Circle_-_Judith_(Official_Video).mkv`
`Led_Zeppelin_-_Whole_Lotta_Love_(Live_at_The_Royal_Albert_Hall,_1970).mkv`

How fields are derived:

- `Artist`: text before `_-_`
- `Title`: text after `_-_` and before the trailing info parentheses
- `Info`: text inside final parentheses

## Parsed Tags and Year

From `Info`, the script maps keywords to `<tag>` entries:

- `Live` -> `Live performance`
- `Official` -> `Official video`
- `Promo` -> `Promo video`
- `AI` -> `AI remaster`
- `fan video` -> `Fan video`
- `Drumcam` -> `Drumcam`

If `Info` ends with `, YYYY`, that year is written to `<premiered>`.

## Usage

Run:

```bash
./bin/mk_video_nfo.sh -d /path/to/videos
```

Example:

```bash
./bin/mk_video_nfo.sh -d "$HOME/Videos/music"
```

Generated files go to:

`/path/to/videos/.output/*.nfo`

## Requirements

- Bash
- Standard Unix tools (`find`, `basename`, `tr`)

## Testing

This project uses ShellSpec.

Run tests:

```bash
shellspec
```

Coverage output is written to:

- `.output/coverage`
- `.output/report`

Open coverage report:

```bash
xdg-open .output/coverage/index.html
```

## CI

GitHub Actions workflow:

- installs ShellSpec and kcov
- runs tests with coverage enabled
- fails if line coverage is below 80%
- uploads coverage artifacts from `.output/coverage` and `.output/report`
