# shellcheck shell=bash

Describe 'mk_video_nfo.sh'
  Include bin/mk_video_nfo.sh

  It 'parses a normal filename correctly'
    parse_filename { Filename="A_Perfect_Circle_-_Judith_\(Official_Video\)" VideoDir=. }
    When call parse_filename
    The variable Title should eq "A Perfect Circle - Judith \(Official Video\)"
    The variable Artist should eq "A Perfect Circle"
    The variable Track should eq "Judith"
    The variable Info should eq "Official Video"
  End
End
