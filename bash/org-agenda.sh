#! /usr/bin/env bash

## Command to create an agenda view from org mode suitable for emails
## and Status Hero.

##          author: torstein@escenic.com
set -o errexit
set -o nounset
set -o pipefail
shopt -s nullglob

main() {
  format=${1-"markdown"}

  now=
  start_date=
  org_agenda=

  now=$(date +%s)
  start_date=$(date +%Y-%m-%d --date @$((now - (60 * 60 * 24 * 7))))
  org_agenda=$(
    emacs -batch -l ~/.emacs.d/tkj-org.el \
          -eval "(org-batch-agenda \"a\"
          org-agenda-start-day \"${start_date}\"
          org-agenda-span 8
          org-agenda-include-diary t
          org-agenda-files (quote (\"~/doc/work.org\" \"~/doc/gcal.org\")))" \
            2>/dev/null)

  result=
  result=$(
    echo "${org_agenda}" |
      egrep -v '^[ ]+[0-9][0-9]?' |
      sed -r 's#gcal.*Scheduled:#Meeting:#' |
      sed -r 's#gcal:.*DONE#Meeting:#' |
      grep -v 'Onelinescrum' |
      egrep -v '^Diary:' |
      egrep -v ':noreport:' |
      sed -r -e 's#:([^:^ ]+)#\#\1 #g' -e 's# :$##' |
      sed -r 's#work:.* Sched.*[0-9]+x:.*STARTED#  CONTINUE#' |
      sed -r 's#work:.* Scheduled:##' |
      sed -r 's#work:.* Sched. [0-9]*x:##' |
      sed -r 's#TODO ##' |
      sed -r 's#PR #⌛ Fixed, awaiting PR: #' |
      sed -r 's#DONE #✔ #' |
      sed -r 's#MERGED #✔ Merged: #'
        )

  if [[ ${format} == "markdown" ]]; then
    echo "${result}" | \
      sed -r 's#^[ ]+#- #'
  else
    echo "${result}"
  fi
}

main "$@"
