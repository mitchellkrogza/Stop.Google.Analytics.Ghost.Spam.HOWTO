#!/bin/bash
# Get Page Titles of Web Sites
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
# Set our Input File
# ******************
_input=$TRAVIS_BUILD_DIR/.dev-tools/_input_source/bad-referrers.list
_output=$TRAVIS_BUILD_DIR/.dev-tools/_output_source/results.csv

# ***************************************************************
# Get our page titles and produce a simple .csv file for analysis
# ***************************************************************

sudo truncate -s 0 $_output
printf '%s%s%s%s%s%s%s\n' "Domain Name" ";" "Status Code" ";" "Content Type" ";" "Redirected To" >> $_output
xargs -n1 -P 10 curl -o /dev/null --silent --head --write-out '%{url_effective};%{http_code};%{content_type};%{redirect_url}\n' < $_input | tee -a $_output

exit 0
