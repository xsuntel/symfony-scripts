#!/bin/bash
# ======================================================================================================================
# Scripts - Tools - AI - Google - Gemini
# ======================================================================================================================
# >>>> Platform
if [ "${PLATFORM_TYPE}" == "Linux" ]; then
  # --------------------------------------------------------------------------------------------------------------------
  # Platform - Linux
  # --------------------------------------------------------------------------------------------------------------------
  # >>>> Environment
  if [ "${ENVIRONMENT_NAME}" == "dev" ]; then
    # >>>> Install
    echo ">>>> Tools - AI - Google - Gemini"
    echo

    # >>>> Directory
    if [ -d "${HOME}/.gemini" ]; then
      # >>>> GEMINI.md
      if [ -f "${PROJECT_PATH}/scripts/tools/ai/google/gemini/GEMINI.md" ]; then
        cp -fv "${PROJECT_PATH}/scripts/tools/ai/google/gemini/GEMINI.md" "${PROJECT_PATH}/GEMINI.md"
        echo
      fi

    fi
  fi
  echo


elif [ "${PLATFORM_TYPE}" == "Darwin" ]; then
  # --------------------------------------------------------------------------------------------------------------------
  # Platform - MacOS
  # --------------------------------------------------------------------------------------------------------------------
  # >>>> Environment
  if [ "${ENVIRONMENT_NAME}" == "dev" ]; then
    # >>>> Install
    echo ">>>> Tools - AI - Google - Gemini"
    echo
  fi
  echo


elif [ "${PLATFORM_TYPE}" == "Windows" ]; then
  # --------------------------------------------------------------------------------------------------------------------
  # Platform - Windows
  # --------------------------------------------------------------------------------------------------------------------
  # >>>> Environment
  if [ "${ENVIRONMENT_NAME}" == "dev" ]; then
    # >>>> Install
    echo ">>>> Tools - AI - Google - Gemini"
    echo
  fi
  echo


else
  echo "Please check Operating System"
  setExit
fi
