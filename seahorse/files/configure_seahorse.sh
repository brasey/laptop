#!/bin/bash

seahorse_path='org.gnome.seahorse'

gsettings set ${seahorse_path} server-auto-publish "true"
gsettings set ${seahorse_path} server-auto-retrieve "true"
gsettings set ${seahorse_path} server-publish-to "'hkp://pool.sks-keyservers.net'"
