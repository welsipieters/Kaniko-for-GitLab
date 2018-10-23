# Kaniko for GitLab

A Docker image that makes it easy to use Kaniko in you GitLab jobs.

Docker image hosted at: https://hub.docker.com/r/mpcref/kaniko-for-gitlab/

.gitlab-ci.yaml example:

```
simple example:
 stage: build and push
 # The image uses the job's credentials by default.
 image: mpcref/kaniko-for-gitlab
 script:
 # The build command wraps /kaniko/executor and uses some
 # default arguments that make sense within a GitLab job
 # For instance, it will use $CI_REGISTRY_IMAGE as the base
 # for the destination. See build.sh source for details.
 - build

more examples:
 stage: build and push
 image: mpcref/kaniko-for-gitlab
 script:
 # If the first argument starts with a ':' or a '/' character,
 # it will be appended to the base destination.
 - build :my-tag
 - build /my-image
 - build /my-image:my-tag
 # Use docker hub as the destination:
 - build my-public-repo/my-image:my-tag
 # All other kaniko arguments (such as no-push) can be used.
 # https://github.com/GoogleContainerTools/kaniko#additional-flags
 - build /foo --no-push
```

Further documentation is coming.
