#!/bin/bash

docker run -it --rm biomotion/ros-with-cuda:10.1-melodic nvcc -V && rosversion -d