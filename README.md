# Forked kaniko-for-gitlab

This repository is a fork of the [kaniko-for-gitlab](https://gitlab.com/cref/docker/kaniko-for-gitlab) project originally created by [Michiel Crefcoeur](https://gitlab.com/cref). The original project provides a convenient wrapper for using Kaniko in GitLab CI environments.

## Why this fork?

The original kaniko-for-gitlab project is an excellent tool that simplifies the use of Kaniko in GitLab CI. However, it was last updated about 5 years ago, and I needed some additional options that weren't available in the original version.

Specifically, this fork adds the ability to:

1. Specify a custom Dockerfile path
2. Pass multiple build arguments to the Kaniko executor

These additions allow for more flexibility in CI/CD pipelines, especially for projects with complex build requirements or non-standard Dockerfile locations.

## Changes from the original

The main changes in this fork are:

1. Modified `build.sh` script to accept `--dockerfile` and `--build-arg` options
2. Default behavior to push images to the GitLab Container Registry
3. Updated documentation to reflect these changes

## Usage

### Basic Usage

To use this forked version of kaniko-for-gitlab in your GitLab CI pipeline, add the following to your `.gitlab-ci.yml` file:

```yaml
build_and_push:
  stage: build
  image: your-registry/kaniko-for-gitlab:latest
  script:
    - build your-image:your-tag
```

This will build the Dockerfile in your project root and push it to your GitLab container registry.

### Advanced Usage with New Features

To take advantage of the new features in this fork, you can use the following options:

1. Specifying a custom Dockerfile:

```yaml
build_and_push:
  stage: build
  image: your-registry/kaniko-for-gitlab:latest
  script:
    - build your-image:your-tag --dockerfile path/to/your/Dockerfile
```

2. Passing build arguments:

```yaml
build_and_push:
  stage: build
  image: your-registry/kaniko-for-gitlab:latest
  script:
    - build your-image:your-tag --build-arg ARG1=value1 --build-arg ARG2=value2
```

3. Combining both options:

```yaml
build_and_push:
  stage: build
  image: your-registry/kaniko-for-gitlab:latest
  script:
    - build your-image:your-tag --dockerfile path/to/your/Dockerfile --build-arg ARG1=value1 --build-arg ARG2=value2
```

### Additional Options

The `build` command supports all the options that Kaniko's executor does. Some commonly used options include:

- `--no-push`: Build the image but don't push it to a registry
- `--cache=true`: Enable caching (default in this wrapper)
- `--cache-repo`: Specify a custom cache repository

Example:

```yaml
build_without_push:
  stage: build
  image: your-registry/kaniko-for-gitlab:latest
  script:
    - build your-image:your-tag --no-push
```

## Acknowledgements

This project builds upon the work done by Michiel Crefcoeur in the original kaniko-for-gitlab project. We are grateful for their initial implementation and the foundation it provided.

If you find these additions useful, feel free to use this fork. However, always check the original repository for any updates or newer versions that might incorporate similar functionality.
