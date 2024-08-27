#!/bin/sh

# Inform the user about the purpose of this command if the context is not a GitLab job.
if [ "$GITLAB_CI" != "true" ]; then
    echo "This command is specifically meant to be called from within a GitLab job."
fi
if [ "$PWD" == "/" ]; then
    echo "WARNING: Kaniko can't handle / as context, make sure to override it!"
fi

# Initialize variables
dockerfile="Dockerfile"
build_args=""
custom_destination=""

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --dockerfile)
            dockerfile="$2"
            shift 2
            ;;
        --build-arg)
            build_args="$build_args --build-arg $2"
            shift 2
            ;;
        *)
            if [ -z "$custom_destination" ]; then
                custom_destination="$1"
            else
                echo "Unknown option: $1"
                exit 1
            fi
            shift
            ;;
    esac
done

# Set up the destination and cache repo
if [ -z "$custom_destination" ]; then
    # No destination specified, use $CI_REGISTRY_IMAGE as default destination
    cache_repo="$CI_REGISTRY_IMAGE/cache"
    dest="$CI_REGISTRY_IMAGE"
elif [[ "$custom_destination" == /* || "$custom_destination" == :* ]]; then
    # Relative destination specified, append to $CI_REGISTRY_IMAGE
    cache_repo="$CI_REGISTRY_IMAGE${custom_destination/:*}/cache"
    dest="$CI_REGISTRY_IMAGE/$custom_destination"
else
    # Absolute destination specified
    cache_repo="${custom_destination/:*}/cache"
    dest="$CI_REGISTRY_IMAGE/$custom_destination"
fi


echo "CI_REGISTRY_IMAGE: $CI_REGISTRY_IMAGE"
echo "Custom Destination: $custom_destination"
echo "Cache Repo: $cache_repo"
echo "Destination: $dest"

# Call Kaniko's executor with some arguments that are helpful within the context of a GitLab job.
# Apparently, the proxy-related build-args are still needed even though these are specified in config.json.
# https://github.com/GoogleContainerTools/kaniko/issues/432
/kaniko/executor \
    --build-arg http_proxy="$http_proxy" \
    --build-arg https_proxy="$https_proxy" \
    --build-arg no_proxy="$no_proxy" \
    --dockerfile="$dockerfile" \
    $build_args \
    --context="$PWD" \
    --cache=true \
    --cache-repo="$cache_repo" \
    --destination="$dest"