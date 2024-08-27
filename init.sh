#!/bin/sh

mkdir -p ~/.docker
echo "{
  \"auths\":{
    \"$CI_REGISTRY\": {
      \"username\":\"gitlab-ci-token\",
      \"password\":\"$CI_JOB_TOKEN\"
    }
  },
  \"credHelpers\": {
    \"gcr.io\":\"gcr\"
  },
  \"proxies\": {
    \"default\": {
      \"ftpProxy\": \"$ftp_proxy\",
      \"httpProxy\": \"$http_proxy\",
      \"httpsProxy\": \"$https_proxy\",
      \"noProxy\": \"$no_proxy\"
    }
  }
}" > ~/.docker/config.json
echo "Using GitLab job credentials for authorization."

# Ugly GitLab shell detection work-around.
# The issue will be resolved by this merge request:
# https://gitlab.com/gitlab-org/gitlab-runner/merge_requests/245
if [ "$1" = "sh" ] && [ "$2" = "-c" ]; then
    shift 2
    code="$@"
else
    code="$@"
fi

# If the command is 'build', use the full path
if [ "$1" = "build" ]; then
    code="/usr/local/bin/build ${@:2}"
fi

sh -c "$code"