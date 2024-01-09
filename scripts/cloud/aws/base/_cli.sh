#!/bin/bash
# ======================================================================================================================
# Scripts - Cloud - AWS - CLI
# ======================================================================================================================
# >>>> Platform                      https://docs.aws.amazon.com/ko_kr/cli/latest/userguide/getting-started-install.html
if [ "${PLATFORM_TYPE}" == "Linux" ]; then
  # --------------------------------------------------------------------------------------------------------------------
  # Linux - Ubuntu
  # --------------------------------------------------------------------------------------------------------------------
  # >>>> AWS - CLI
  local addPackageList="python3-pip awscli"
  for pkgItem in ${addPackageList}; do
    local APT_PKG_INFO
    APT_PKG_INFO=$(dpkg -l | grep -i "${pkgItem}" | awk '{print $2}' | cut -d ':' -f1 | awk "/^${pkgItem}$/")
    if [ "${APT_PKG_INFO}" != ${pkgItem} ]; then
      sudo apt install -y ${pkgItem}
      echo
    fi
  done
elif [ "${PLATFORM_TYPE}" == "Darwin" ]; then
  # --------------------------------------------------------------------------------------------------------------------
  # MacOS
  # --------------------------------------------------------------------------------------------------------------------
  # >>>> Python
  local PYTHON_PKG
  PYTHON_PKG=$(brew list | grep python)
  if [ "${PYTHON_PKG}" ]; then
    echo "Python has been installed"
  else
    brew install python
  fi
  echo

  # >>>> AWS - CLI
  local AWS_CLI
  AWS_CLI=$(which aws)
  if [ "${AWS_CLI}" == "/usr/local/bin/aws" ]; then
    echo aws --version
  else
    (
      if [ -d ~/Downloads ]; then
        cd ~/Downloads || return

        curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
        sudo installer -pkg AWSCLIV2.pkg -target /
      fi
    )
  fi
elif [ "${PLATFORM_TYPE}" == "Windows" ]; then
  # --------------------------------------------------------------------------------------------------------------------
  # Windows
  # --------------------------------------------------------------------------------------------------------------------
  # >>>> Python

  # >>>> AWS - CLI

  echo - n
else
  echo "Please check Operating System"
  setEnd
fi

# ======================================================================================================================
# Scripts - Cloud - AWS - SDK
# ======================================================================================================================

# >>>> AWS - CLI                         https://docs.aws.amazon.com/ko_kr/cli/latest/userguide/cli-configure-files.html
aws configure list
echo

# ----------------------------------------------------------------------------------------------------------------------
# AWS - CodeCommit                            https://docs.aws.amazon.com/ko_kr/codecommit/latest/userguide/welcome.html
# ----------------------------------------------------------------------------------------------------------------------
# >>>> AWS - Repositories
#aws codecommit list-repositories


# >>>> AWS - Git              https://docs.aws.amazon.com/ko_kr/codecommit/latest/userguide/setting-up-https-unixes.html
#git config --local credential.helper '!aws codecommit credential-helper $@'
#git config --local credential.UseHttpPath true
#git config --local http.sslVerify false
#echo
