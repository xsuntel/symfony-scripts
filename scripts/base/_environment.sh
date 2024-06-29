#!/bin/bash
# ======================================================================================================================
# Scripts - Environment
# ======================================================================================================================

# >>>> MENU
PS3="Menu: "
select num in "dev" "prod" "exit"; do
  case "$REPLY" in
  1)
    # >>>> DEV  Environment
    ENVIRONMENT_NAME="dev"
    break
    ;;
  2)
    # >>>> PROD Environment
    ENVIRONMENT_NAME="prod"
    break
    ;;
  3)
    echo "exit()"
    setEnd
    ;;
  *)
    echo "[ ERROR ] Unknown Command"
    setEnd
    ;;
  esac
done

echo
echo "- ENVIRONMENT NAME : ${ENVIRONMENT_NAME}"
echo