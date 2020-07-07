#!/bin/bash

buildctl build \
    --frontend=dockerfile.v0 \
    --local context=../../ \
    --progress plain \
    --local dockerfile=. \
    --output type=docker,name=kaldi-trunk | docker load
