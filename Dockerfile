FROM phusion/baseimage:0.9.18
# Use baseimage-docker's init system
CMD ["/sbin/my_init"]

MAINTAINER Kyle Wilcox <kyle@axiomdatascience.com>
ENV DEBIAN_FRONTEND noninteractive
ENV LANG C.UTF-8

# Setup CONDA (https://hub.docker.com/r/continuumio/miniconda3/~/dockerfile/)
RUN apt-get update && apt-get install -y \
    git \
    wget \
    bzip2 \
    ca-certificates \
    libglib2.0-0 \
    libxext6 \
    libsm6 \
    libxrender1 \
    pwgen \
    binutils \
    freetds-bin \
    freetds-common \
    freetds-dev \
    python-pip \
    python-dev \
    build-essential \

&& apt-get clean \
&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV LUIGI_CONFIG_PATH /etc/luigi/luigi.conf

# Install requirements
ADD requirements.txt /tmp/
RUN pip install -r /tmp/requirements.txt

RUN mkdir /etc/luigi
ADD logging.conf /etc/luigi/
ADD luigi.conf /etc/luigi/
VOLUME /etc/luigi

RUN mkdir -p /luigi/logs
VOLUME /luigi/logs

RUN mkdir -p /luigi/state
VOLUME /luigi/state

EXPOSE 8082

RUN mkdir /etc/service/luigid
COPY luigid.sh /etc/service/luigid/run
