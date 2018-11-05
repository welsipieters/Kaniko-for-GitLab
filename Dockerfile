# GitLab requires a shell so we use debug as base image.
FROM gcr.io/kaniko-project/executor:debug
LABEL Description="A Docker image that makes it easy to use Kaniko in you GitLab jobs. More info: https://gitlab.com/mpcref/kaniko-for-gitlab" Version="1.0"
# Make RUN commands work.
SHELL ["sh", "-c"]
# Make sure the initialization script will always get called.
ENTRYPOINT ["sh", "init"]
COPY build.sh /usr/local/bin/build
COPY init.sh init
# Execute the build command by default.
CMD build
