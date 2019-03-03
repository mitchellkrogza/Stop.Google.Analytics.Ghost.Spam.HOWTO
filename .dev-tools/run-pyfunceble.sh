#!/bin/bash
# ********************
# Run PyFunceble Testing
# ********************

# ****************************************************************
# This uses the awesome funceble script created by Nissar Chababy
# Find funceble at: https://github.com/funilrys/PyFunceble
# ****************************************************************

# ******************
# Set our Input File
# ******************

_input=${TRAVIS_BUILD_DIR}/.dev-tools/_input_source/bad-referrers.list

# *******************************************
# Make Sure We Are In The Travis Build Folder
# *******************************************

cd ${TRAVIS_BUILD_DIR}/.dev-tools/_pyfunceble/

# *************************
# Run Funceble Install Tool
# *************************

YEAR=$(date +%Y)
MONTH=$(date +%m)

# ************************************
#  Run PyFunceble and Check Domains List
# ************************************

PyFunceble --travis -a -ex --plain --cmd-before-end "bash ${TRAVIS_BUILD_DIR}/.dev-tools/final-commit.sh" -f $_input --commit-autosave-message "V1.${YEAR}.${MONTH}.${TRAVIS_BUILD_NUMBER} [PyFunceble]" --commit-results-message "V1.${YEAR}.${MONTH}.${TRAVIS_BUILD_NUMBER}"

exit ${?}
