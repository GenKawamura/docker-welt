FROM ubuntu:18.04

## Workdir
ENV workdir /work
WORKDIR ${workdir}
RUN mkdir -p ${workdir} &&  chmod 1777 ${workdir}

## Installing Python3 and packages
RUN apt-get update && apt-get -y upgrade python3
RUN apt-get -y install python3-pip
RUN pip3 install --upgrade pip
RUN pip3 install tensorflow
RUN pip3 install h5py
RUN pip3 install keras
RUN pip3 install chainer pandas-ml opencv-python


## Installing some tools
RUN apt-get install -yq git
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get -y install tzdata


# User
RUN adduser user1000 --disabled-password && adduser user1001 --disabled-password
USER user1000
