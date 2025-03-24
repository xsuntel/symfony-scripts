#!/bin/bash
# ======================================================================================================================
# Scripts - Base - Symfony - Git                                                                    https://git-scm.com/
# ======================================================================================================================

# >>>> Git - Config

echo ">>>> Git - Global"
echo

git config --global --list
echo

echo ">>>> Git - Local"
echo

local GIT_SAFE_DIRECTORY
GIT_SAFE_DIRECTORY=$(git config --local --list | grep -i "${PROJECT_PATH}")
if [ ! "${GIT_SAFE_DIRECTORY}" ]; then
  git config --local --add safe.directory "${PROJECT_PATH}"
fi
git config --local core.editor vi
git config --local core.autocrlf false
git config --local color.ui true
git config --local diff.ui auto
git config --local format.pretty oneline
git config --local pull.rebase true
git config --local push.default simple

git config --local --list
echo