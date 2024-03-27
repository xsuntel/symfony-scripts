#!/bin/bash
# ======================================================================================================================
# Scripts - Tools - Git - Remote - Config
# ======================================================================================================================
# >>>> Global
if [ -d app ]; then
  (
    cd app || return

    # >>>> Git - User                                                                               https://git-scm.com/
    git config --global user.name "${GIT_CONFIG_GLOBAL_USER_NAME}"
    git config --global user.email "${GIT_CONFIG_GLOBAL_USER_EMAIL}"

    # >>>> Git - Config - Global
    git config --global init.defaultBranch main
    git config --global core.editor vi
    git config --global core.autocrlf false
    git config --global color.ui true
    git config --global diff.ui auto
    git config --global format.pretty oneline
    git config --global push.default simple

    git config --global credential.helper store

    local GIT_SAFE_DIRECTORY
    GIT_SAFE_DIRECTORY=$(git config --global --list | grep -i "${PROJECT_PATH}")
    if [ ! "${GIT_SAFE_DIRECTORY}" ]; then
      git config --global --add safe.directory "${PROJECT_PATH}"
    fi
  )
  echo "This global configuration has been updated"
else
  echo
  echo "[ ERROR ] There is not a folder : app"
fi