FROM gcr.io/kaniko-project/executor:debug
# Make RUN commands work.
SHELL ["sh", "-c"]
# Make sure the initialization script will always get called.
ENTRYPOINT ["sh", "init"]
RUN mkdir -p ~/.docker
COPY build.sh /usr/local/bin/build
COPY init.sh init
# Execute the build command by default.
CMD build
