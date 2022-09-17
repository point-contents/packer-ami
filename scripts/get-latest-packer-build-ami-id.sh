#! /usr/bin/env bash

# Searches the manifest folder and gets the latest ami image id output from packer

pushd manifest && latest_manifest=$(find . -iname "*.json" | sort -nr | head -n 1)

latest_ami=$(grep "artifact" $latest_manifest | cut -d ':' -f 2,3  | sed 's:,:: ; s:\"::g ; s: ::g')

region=$(echo $latest_ami | cut -d ':' -f 1)
ami=$(echo $latest_ami | cut -d ':' -f 2)

printf "Region: %s AMI ID: %s\n" $region $ami 
popd

