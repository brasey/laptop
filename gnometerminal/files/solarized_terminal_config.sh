#!/bin/bash

profile_id='b1dcc9dd-5262-4d8d-a863-c897e6d979b9'
profile_path="/org/gnome/terminal/legacy/profiles:/:${profile_id}"

dconf write ${profile_path}/visible-name "'brasey'"
dconf write ${profile_path}/default-size-rows "42"
dconf write ${profile_path}/default-size-columns "124"
dconf write ${profile_path}/use-system-font "true"
dconf write ${profile_path}/use-custom-default-size "true"
dconf write ${profile_path}/use-theme-colors "false"
dconf write ${profile_path}/scrollback-unlimited "true"
dconf write ${profile_path}/scrollbar-policy "'always'"
dconf write ${profile_path}/foreground-color "'#838394949696'"
dconf write ${profile_path}/background-color "'#00002B2B3636'"
dconf write ${profile_path}/bold-color "'#9393a1a1a1a1'"
dconf write ${profile_path}/bold-color-same-as-fg "false"
dconf write ${profile_path}/palette "[ '#070736364242', '#DCDC32322F2F', '#858599990000', '#B5B589890000', '#26268B8BD2D2', '#D3D336368282', '#2A2AA1A19898', '#EEEEE8E8D5D5', '#00002B2B3636', '#CBCB4B4B1616', '#58586E6E7575', '#65657B7B8383', '#838394949696', '#6C6C7171C4C4', '#9393A1A1A1A1', '#FDFDF6F6E3E3' ]"
