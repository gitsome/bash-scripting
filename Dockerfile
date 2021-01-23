FROM ubuntu:20.04
RUN apt-get update
RUN apt-get install -y man
RUN apt-get install -y less
RUN apt-get install -y mlocate
