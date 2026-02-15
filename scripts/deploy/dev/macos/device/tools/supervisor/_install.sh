#!/bin/bash
# ======================================================================================================================
# Scripts - Deploy - Dev - MacOS
# ======================================================================================================================
# >>>> Platform
if [ "${PLATFORM_TYPE}" == "Darwin" ]; then

    # >>>> Environment
    if [ "${ENVIRONMENT_NAME}" == "dev" ]; then

        # >>>> Process
        echo ">>>> MacOS - Process - Supervisor"
        echo

        local SUPERVISOR_STATUS
        SUPERVISOR_STATUS=$(brew list | grep -i "supervisor" | awk "/^supervisor$/")
        if [ "${SUPERVISOR_STATUS}" != "supervisor" ]; then
            brew install supervisor
            echo

            if [ ! -d /opt/homebrew/etc/supervisor.d ]; then
            mkdir -p /opt/homebrew/etc/supervisor.d
            fi
        fi

        if [ ! -f /opt/homebrew/etc/supervisor.d/messenger-consume.ini ]; then
            if [ -f "${PROJECT_PATH}"/scripts/deploy/dev/macos/device/tools/supervisor/conf.d/messenger-consume.ini ]; then
            cp -fv "${PROJECT_PATH}"/scripts/deploy/dev/macos/device/tools/supervisor/conf.d/messenger-consume.ini /opt/homebrew/etc/supervisor.d/messenger-consume.ini
            echo
            fi
        fi

        supervisorctl stop messenger-consume:*
        echo

        supervisorctl status
        echo

    fi
fi
