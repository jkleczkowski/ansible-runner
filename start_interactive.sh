#!/bin/bash

docker run -t -i --name ans --rm \
    -v ~/.ssh:/root/.ssh \
    -v $(pwd):/ansible
    jkleczkowski/ansible-runner
