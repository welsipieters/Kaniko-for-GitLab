# GitLab requires a shell so we use debug as base image.
FROM gcr.io/kaniko-project/executor:debug
LABEL Description="A Docker image that makes it easy to use Kaniko in you GitLab jobs. More info: https://github.com/welsipieters/Kaniko-for-GitLab" Version="1.1"

# Make RUN commands work.
SHELL ["sh", "-c"]

# Copy the build script and init script.
COPY build.sh /usr/local/bin/build
COPY init.sh /usr/local/bin/init


# Make scripts executable
RUN chmod +x /usr/local/bin/build /usr/local/bin/init

# Set up the entrypoint
ENTRYPOINT ["sh", "/usr/local/bin/init"]

# Execute the build command by default.
CMD ["build"]
