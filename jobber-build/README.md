# Build Image

~~~~
$ docker build -t jobber-build .
~~~~

# Release

~~~~
$ docker run --rm \
    -v $(pwd)/release:/release \
    jobber-build
~~~~
