#!/bin/bash

if [[ $# < 1 ]]
then
  echo '
Hide project names and password from files

Use: '$0' <file>
Example: '$0' httpd_log
'
  exit 1
fi

sed -e 's/foo-project/REDACTED1/g' \
    -e 's/bar-project/REDACTED2/g' $1 |\
sed -E 's/(password[ ]*=[ ]*).*$/\1REDACTEDPSW/gI' > $1.redacted
