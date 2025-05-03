#!/bin/bash
# ======================================================================================================================
# Scripts - Base - Symfony - Git                                                                    https://git-scm.com/
# ======================================================================================================================

# >>>> Git - Config

echo ">>>> Git - Global"
echo

# >>>> Platform
if [ "${PLATFORM_TYPE}" == "Linux" ]; then

  git config --global core.autocrlf input

elif [ "${PLATFORM_TYPE}" == "Darwin" ]; then

  git config --global core.autocrlf input

elif [ "${PLATFORM_TYPE}" == "Windows" ]; then

  git config --global core.autocrlf true

else
  echo "Please check Operating System"
  setExit
fi

git config --global --list
echo

echo ">>>> Git - Local"
echo

local GIT_SAFE_DIRECTORY
GIT_SAFE_DIRECTORY=$(git config --local --list | grep -i "${PROJECT_PATH}")
if [ ! "${GIT_SAFE_DIRECTORY}" ]; then
  git config --local --add safe.directory "${PROJECT_PATH}"
fi

# >>>> Platform
if [ "${PLATFORM_TYPE}" == "Linux" ]; then

  git config --local  core.autocrlf input

elif [ "${PLATFORM_TYPE}" == "Darwin" ]; then

  git config --locla  core.autocrlf input

elif [ "${PLATFORM_TYPE}" == "Windows" ]; then

  git config --local  core.autocrlf true

else
  echo "Please check Operating System"
  setExit
fi

git config --local core.editor vi
git config --local color.ui true
git config --local diff.ui auto
git config --local format.pretty oneline
git config --local pull.rebase true
git config --local push.default simple

git config --local --list
echo