#!/bin/bash
# ********************
# Run PyFunceble Testing
# ********************

# ******************
# Set our Input File
# ******************

_input=./dev-tools/_input_source/bad-referrers.list

# *************************
# Run Funceble Install Tool
# *************************

YEAR=$(date +%Y)
MONTH=$(date +%m)

RunFunceble () {

    yeartag=$(date +%Y)
    monthtag=$(date +%m)
    ulimit -u

    hash PyFunceble

    if [[ -f "${pyfuncebleConfigurationFileLocation}" ]]
    then
        rm "${pyfuncebleConfigurationFileLocation}"
        rm "${pyfuncebleProductionConfigurationFileLocation}"
    fi

    export PYFUNCEBLE_CONFIG_DIR="./dev-tools/.pyfunceble"

    PyFunceble --ci --ci-branch dev --ci-distribution-branch --plain -w 10 -dbr 5 -ex --dns 1.1.1.1 1.0.0.1 --ci-max-minutes 20 --ci-end-command "bash ./dev-tools/final-commit.sh" --ci-commit-message "V1.${yeartag}.${monthtag}.${TRAVIS_BUILD_NUMBER} [PyFunceble]" --ci-end-commit-message "V1.${yeartag}.${monthtag}.${TRAVIS_BUILD_NUMBER}" -f ${_input}

}

RunFunceble


exit ${?}
