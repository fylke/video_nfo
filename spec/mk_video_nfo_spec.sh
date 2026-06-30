# shellcheck shell=bash

Describe 'mk_video_nfo.sh'
  Include bin/mk_video_nfo.sh

  It 'parses a normal filename correctly'
    parse_filename() {
      Filename="A_Perfect_Circle_-_Judith_(Official_Video)"
      VideoDir=.
      tokenize_filename
    }
    When call parse_filename
    The variable Artist should eq "A Perfect Circle"
    The variable Title should eq "Judith (Official Video)"
    The variable Info should eq "Official Video"
  End

  It 'parses info into year'
    parse_info() {
      Info="Live_Official_Promo_AI_fan video_Drumcam, 2021"
      tokenize_info
    }
    When call parse_info
    The variable Premiered should eq "2021"
  End

  It 'parses info into tags'
    parse_info() {
      Info="Live_Official_Promo_AI_fan video_Drumcam, 2021"
      tokenize_info
    }

    When call parse_info
    The variable Tags should eq $'Live performance\nOfficial video\nPromo video\nAI remaster\nFan video\nDrumcam\n'
  End
End
