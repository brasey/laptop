#!/bin/bash

dejadup_path='/org/gnome/dejadup'

dconf write ${dejadup_path}/backend "'file'"
dconf write ${dejadup_path}/exclude-list "['$TRASH', '$DOWNLOAD', '/home/brasey/.local', '/home/brasey/.juniper_networks']"
dconf write ${dejadup_path}/periodic-period "1"
dconf write ${dejadup_path}/welcomed "true"
dconf write ${dejadup_path}/file/path "'sftp://pi@10.0.0.18/mnt/iosafe/manheim-laptop'"

