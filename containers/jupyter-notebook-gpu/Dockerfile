#https://gitlab.com/nvidia/container-images/cuda/blob/master/dist/ubuntu18.04/10.1/base/Dockerfile
FROM docker-welt/tensorflow-gpu

USER root

## Installing some tools
RUN apt-get update && apt-get install -y firefox jupyter python3-pandas python3-sklearn

# User
USER user1000
