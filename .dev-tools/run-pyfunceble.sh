#!/bin/bash
# ********************
# Run PyFunceble Testing
# ********************

# ******************
# Set our Input File
# ******************

_input=${TRAVIS_BUILD_DIR}/.dev-tools/_input_source/bad-referrers.list

# *************************
# Run Funceble Install Tool
# *************************

YEAR=$(date +%Y)
MONTH=$(date +%m)

RunFunceble () {

    yeartag=$(date +%Y)
    monthtag=$(date +%m)
    ulimit -u
    cd ${TRAVIS_BUILD_DIR}/.dev-tools

    hash PyFunceble

    if [[ -f "${pyfuncebleConfigurationFileLocation}" ]]
    then
        rm "${pyfuncebleConfigurationFileLocation}"
        rm "${pyfuncebleProductionConfigurationFileLocation}"
    fi

    PyFunceble --ci -dbr 5 -ex --idna --dns 1.1.1.1 1.0.0.1 --cmd-before-end "bash ${TRAVIS_BUILD_DIR}/.dev-tools/final-commit.sh" --plain --autosave-minutes 20 --commit-autosave-message "V1.${yeartag}.${monthtag}.${TRAVIS_BUILD_NUMBER} [PyFunceble]" --commit-results-message "V1.${yeartag}.${monthtag}.${TRAVIS_BUILD_NUMBER}" -f ${_input}

}

RunFunceble


exit ${?}
