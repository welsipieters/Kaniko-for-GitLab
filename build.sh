# Inform the user about the purpose of this command if the context is not a GitLab job.
if [ "$GITLAB_CI" != "true" ]; then
    echo "This command is specifically meant to be called from within a GitLab job."
fi
if [ "$PWD" == "/" ]; then
    echo "WARNING: Kaniko can't handle / as context, make sure to override it!"
fi

# Get destination from first argument (if specified) and work around Kaniko's
# quirky default behavior concerning cache-repo when a destination is specified.
case $1 in
""|-*)
    # No destination specified, use $CI_REGISTRY_IMAGE as default destination.
    rest="$CI_REGISTRY_IMAGE/cache --destination=$CI_REGISTRY_IMAGE $@"
    ;;
[/:]*)
    # Relative destination specified, append to $CI_REGISTRY_IMAGE default destination.
    rest="$CI_REGISTRY_IMAGE${1/:*}/cache --destination=$CI_REGISTRY_IMAGE$@"
    ;;
*)
    # Absolute destination specified.
    rest="${1/:*}/cache --destination=$@"
    ;;
esac

# It appears that Kaniko doesn't write any blobs to the cache-dir yet... :(
echo Please ignore the warning about retrieving image from cache.
# Call Kaniko's executor with some arguments that are helpful within the context of a GitLab job.
/kaniko/executor \
    --build-arg http_proxy="$http_proxy" \
    --build-arg https_proxy="$https_proxy" \
    --build-arg no_proxy="$no_proxy" \
    --context="$PWD" \
    --cache=true \
    --cache-repo=$rest
