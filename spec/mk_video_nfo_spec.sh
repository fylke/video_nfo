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

  It 'generates nfo files in the output directory'
    generate_nfo() {
      temp_dir="$(mktemp -d)"
      trap 'rm -rf "${temp_dir}"' EXIT

      touch "${temp_dir}/A_Perfect_Circle_-_Judith_(Official_Video,_2000).mkv"
      main -d "${temp_dir}"
      test -f "${temp_dir}/.output/A_Perfect_Circle_-_Judith_(Official_Video,_2000).nfo"
    }

    When call generate_nfo
    The status should be success
  End

  It 'writes expected metadata into generated nfo'
    render_nfo() {
      temp_dir="$(mktemp -d)"
      trap 'rm -rf "${temp_dir}"' EXIT

      touch "${temp_dir}/A_Perfect_Circle_-_Judith_(Live_Official_Promo_AI_fan video_Drumcam,_2000).mkv"
      main -d "${temp_dir}"
      cat "${temp_dir}/.output/A_Perfect_Circle_-_Judith_(Live_Official_Promo_AI_fan video_Drumcam,_2000).nfo"
    }

    When call render_nfo
    The output should include '<premiered>2000</premiered>'
    The output should include '<tag>Live performance</tag>'
    The output should include '<tag>Official video</tag>'
    The output should include '<tag>Promo video</tag>'
    The output should include '<tag>AI remaster</tag>'
    The output should include '<tag>Fan video</tag>'
    The output should include '<tag>Drumcam</tag>'
  End

  It 'shows usage for invalid directory'
    When run main -d /definitely/not/a/real/path
    The status should eq 1
    The stderr should include 'Usage:'
  End
End
