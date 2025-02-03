#!/bin/bash

run_lint() {
  shellcheck ./"$1"
}

run_lint update_mise.sh
run_lint utils/changelog.sh
run_lint utils/clean.sh
run_lint utils/create-patch.sh
run_lint utils/format.sh
run_lint utils/install.sh
run_lint utils/lint.sh
run_lint utils/git-clean-fetch.sh
