#!/bin/bash
# Travis CI Generating and Building for the Google Analytics Ghost Spam Blocker
# Created by: Mitchell Krog (mitchellkrog@gmail.com)
# Copyright: Mitchell Krog - https://github.com/mitchellkrogza
# Repo Url: https://github.com/mitchellkrogza/Stop.Google.Analytics.Ghost.Spam.HOWTO

# MIT License

# Copyright (c) 2017 Mitchell Krog - mitchellkrog@gmail.com
# https://github.com/mitchellkrogza

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

# ******************
# Set Some Variables
# ******************

YEAR=$(date +"%Y")
cd $TRAVIS_BUILD_DIR
_input=$TRAVIS_BUILD_DIR/.dev-tools/_input_source/bad-referrers.list
_input2=$TRAVIS_BUILD_DIR/.dev-tools/domains_tmp.txt

# *********************************************
# Sort our list alphabetically and remove dupes
# *********************************************

sudo sort -u $_input -o $_input

# *******************************
# Remove Remote Added by TravisCI
# *******************************

git remote rm origin

# **************************
# Add Remote with Secure Key
# **************************

git remote add origin https://${GOOGLESPAM_TOKEN}@github.com/${TRAVIS_REPO_SLUG}.git

# *********************
# Set Our Git Variables
# *********************

git config --global user.email "${GIT_EMAIL}"
git config --global user.name "${GIT_NAME}"
git config --global push.default simple

# *******************************************
# Make sure we have checked out master branch
# *******************************************

git checkout master

# ***************************************************
# Set our scripts to be executable
# ***************************************************

sudo chmod +x $TRAVIS_BUILD_DIR/.dev-tools/modify-readme.sh
sudo chmod +x $TRAVIS_BUILD_DIR/.dev-tools/generate-google-exclude.php
sudo chmod +x $TRAVIS_BUILD_DIR/.dev-tools/install-run-funceble.sh
sudo chmod +x $TRAVIS_BUILD_DIR/.dev-tools/final-commit.sh
sudo chmod +x $TRAVIS_BUILD_DIR/.dev-tools/deploy-test2.sh

# *****************
# Activate Dos2Unix
# *****************

dos2unix $_input

# ******************************************
# Trim Empty Line at Beginning of Input File
# ******************************************

grep '[^[:blank:]]' < $_input > $_input2
sudo mv $_input2 $_input

# ********************************************************
# Clean the list of any lines not containing a . character
# ********************************************************

cat $_input | sed '/\./!d' > $_input2 && mv $_input2 $_input

# **************************************************************************************
# Strip out our Dead Domains / Whitelisted Domains and False Positives from CENTRAL REPO
# **************************************************************************************


# ***************************************************************************************************
# First Run our Cleaner to remove all Dead Domains from 
# https://github.com/mitchellkrogza/CENTRAL-REPO.Dead.Inactive.Whitelisted.Domains.For.Hosts.Projects
# ***************************************************************************************************

printf '\n%s\n%s\n%s\n\n' "##########################" "Stripping out Dead Domains" "##########################"

sudo wget https://raw.githubusercontent.com/mitchellkrogza/CENTRAL-REPO.Dead.Inactive.Whitelisted.Domains.For.Hosts.Projects/master/dead-domains.txt -O $TRAVIS_BUILD_DIR/.input_sources/.False-Positives-Dead-Domains/dead-domains.txt

_deaddomains=$TRAVIS_BUILD_DIR/.input_sources/.False-Positives-Dead-Domains/dead-domains.txt
_deadtemp=$TRAVIS_BUILD_DIR/.input_sources/.False-Positives-Dead-Domains/temp_dead_domains.txt

sort -u $_deaddomains -o $_deaddomains
sort -u $_input -o $_input

awk 'NR==FNR{a[$0];next} !($0 in a)' $_deaddomains $_input > $_deadtemp && mv $_deadtemp $_input

sort -u $_input -o $_input

printf '\n%s\n%s\n%s\n\n' "###############################" "END: Stripping out Dead Domains" "###############################"

# ***************************************************************************************************
# Run our Cleaner to remove all False Positive Domains from 
# https://github.com/mitchellkrogza/CENTRAL-REPO.Dead.Inactive.Whitelisted.Domains.For.Hosts.Projects
# ***************************************************************************************************

printf '\n%s\n%s\n%s\n\n' "####################################" "Stripping out False Positive Domains" "####################################"

sudo wget https://raw.githubusercontent.com/mitchellkrogza/CENTRAL-REPO.Dead.Inactive.Whitelisted.Domains.For.Hosts.Projects/master/false-positives.txt -O $TRAVIS_BUILD_DIR/.input_sources/.False-Positives-Dead-Domains/false-positives.txt

_falsepositives=$TRAVIS_BUILD_DIR/.input_sources/.False-Positives-Dead-Domains/false-positives.txt
_falsepositivestemp=$TRAVIS_BUILD_DIR/.input_sources/.False-Positives-Dead-Domains/temp_false_positives.txt

sort -u $_falsepositives -o $_falsepositives

awk 'NR==FNR{a[$0];next} !($0 in a)' $_falsepositives $_input > $_falsepositivestemp && mv $_falsepositivestemp $_input

sort -u $_input -o $_input

printf '\n%s\n%s\n%s\n\n' "#########################################" "END: Stripping out False Positive Domains" "#########################################"

# ***************************************************************************************************
# Run our Cleaner to remove all Whitelisted Domains from 
# https://github.com/mitchellkrogza/CENTRAL-REPO.Dead.Inactive.Whitelisted.Domains.For.Hosts.Projects
# ***************************************************************************************************

printf '\n%s\n%s\n%s\n\n' "#################################" "Stripping out Whitelisted Domains" "#################################"

sudo wget https://raw.githubusercontent.com/mitchellkrogza/CENTRAL-REPO.Dead.Inactive.Whitelisted.Domains.For.Hosts.Projects/master/whitelist-domains.txt -O $TRAVIS_BUILD_DIR/.input_sources/.False-Positives-Dead-Domains/whitelist-domains.txt

_whitelist=$TRAVIS_BUILD_DIR/.input_sources/.False-Positives-Dead-Domains/whitelist-domains.txt
_whitelisttemp=$TRAVIS_BUILD_DIR/.input_sources/.False-Positives-Dead-Domains/temp_whitelisted.txt

sort -u $_whitelist -o $_whitelist

awk 'NR==FNR{a[$0];next} !($0 in a)' $_whitelist $_input > $_whitelisttemp && mv $_whitelisttemp $_input

sort -u $_input -o $_input

printf '\n%s\n%s\n%s\n\n' "######################################" "END: Stripping out Whitelisted Domains" "######################################"

# ************************************************
# Activate Dos2Unix One Last Time and Re-Sort List
# ************************************************

dos2unix $_input

# ***************************************************
# Run funceble to check for dead domains
# ***************************************************

sudo sh -x $TRAVIS_BUILD_DIR/.dev-tools/install-run-funceble.sh

# *************************************************************
# Travis now moves to the before_deploy: section of .travis.yml
# *************************************************************

# MIT License

# Copyright (c) 2017 Mitchell Krog - mitchellkrog@gmail.com
# https://github.com/mitchellkrogza

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.