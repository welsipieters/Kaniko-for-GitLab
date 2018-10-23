echo "{\"auths\":{\"$CI_REGISTRY\":{\"username\":\"gitlab-ci-token\",\"password\":\"$CI_JOB_TOKEN\"}},\"credHelpers\":{\"gcr.io\":\"gcr\"}}" > ~/.docker/config.json
echo "Using GitLab job credentials for authorization."
# Ugly GitLab shell detection work-around.
# The issue will be resolved by this merge request:
# https://gitlab.com/gitlab-org/gitlab-runner/merge_requests/245
if [ "$1 $2" == "sh -c" ]; then
    code=$3
else
    code=$@
fi
# Run the code.
eval "$code"
