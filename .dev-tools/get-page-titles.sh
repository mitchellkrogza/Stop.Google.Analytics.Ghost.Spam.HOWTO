#!/bin/bash
# Get Page Titles of Web Sites

# ******************
# Set our Input File
# ******************
_input=$TRAVIS_BUILD_DIR/.dev-tools/_input_source/bad-referrers.list
_output=$TRAVIS_BUILD_DIR/.dev-tools/_output_source/page-titles.list

# ************************************
# Get our page titles
# ************************************

while IFS= read -r LINE
do
#printf '\t"~*%s%s%s"\t\t%s\n' "\b" "${LINE}" "\b" "$_action1" >> "$_tmpnginx1"
#wget -qO- '${LINE}' |   perl -l -0777 -ne 'print $1 if /<title.*?>\s*(.*?)\s*<\/title/si' >> $_output
curl -s ${LINE} | grep -o "<title>[^<]*" | cut -d'>' -f2-  >> $_output
done < $_input

