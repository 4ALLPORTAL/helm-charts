#!/usr/bin/env bash

set -exu
set -o pipefail

: "${PR_TITLE:?Environment variable must be set}"

repo_root=$(git rev-parse --show-toplevel)

changed=$(ct list-changed --config "$repo_root/ct.yaml")

if [[ -z "$changed" ]]; then
    exit 0
fi

num_changed=$(wc -l <<< "$changed")

if ((num_changed > 1)); then
    echo "This PR has changes to multiple charts. Please create individual PRs per chart." >&2
    exit 1
fi

# Strip charts directory
changed="${changed##*/}"

if [[ "$PR_TITLE" != "[$changed] "* ]]; then
    echo "PR title must start with '[$changed] '." >&2
    exit 1
fi
