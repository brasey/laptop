#!/bin/bash

dejadup_path='org.gnome.DejaDup'

gsettings set ${dejadup_path} backend "'file'"
gsettings set ${dejadup_path} exclude-list "['$TRASH', '$DOWNLOAD', '/home/brasey/.local', '/home/brasey/.juniper_networks']"
gsettings set ${dejadup_path} periodic-period "1"
gsettings set ${dejadup_path} welcomed "true"
gsettings set ${dejadup_path}.File path "'sftp://pi@10.0.0.18/mnt/iosafe/manheim-laptop'"

