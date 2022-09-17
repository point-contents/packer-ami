#! /usr/bin/env bash

echo "Installing Tmux"
sudo dnf install tmux openscap openscap-utils scap-security-guide -y
echo "this is a html file" >> ~/file.html
#sudo oscap xccdf eval --profile cis_server_l1 --fetch-remote-resources --report ~/`hostname`-ssg-results.html /usr/share/xml/scap/ssg/content/ssg-almalinux8-xccdf.xml
