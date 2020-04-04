FROM nvidia/cuda:10.1-cudnn7-runtime-ubuntu18.04

# setup environment
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8

# setup timezone & install packages
ENV DEBIAN_FRONTEND=noninteractive
RUN echo 'Etc/UTC' > /etc/timezone && \
    ln -s /usr/share/zoneinfo/Etc/UTC /etc/localtime && \
    apt-get update && apt-get install -q -y \
    dirmngr \
    gnupg2 \
    wget \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# RUN pip install numpy

# setup keys and sources.list
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654 && \
    echo "deb http://packages.ros.org/ros/ubuntu bionic main" > /etc/apt/sources.list.d/ros1-latest.list

# install bootstrap tools
RUN apt-get update && apt-get install --no-install-recommends -y \
    python-rosdep \
    python-rosinstall \
    python-vcstools \
    && rm -rf /var/lib/apt/lists/*

ENV ROS_DISTRO melodic
# bootstrap rosdep
RUN rosdep init && \
    rosdep update --rosdistro $ROS_DISTRO

# install ros packages
RUN apt-get update && apt-get install -y \
    ros-melodic-ros-core=1.4.1-0* \
    && rm -rf /var/lib/apt/lists/*

# install cuda library
RUN wget https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64/libcudnn7-dev_7.6.5.32-1+cuda10.1_amd64.deb -O libcudnn-dev.deb && \
    dpkg -i libcudnn-dev.deb && \
    rm libcudnn-dev.deb


# setup entrypoint
COPY ./ros_entrypoint.sh /

ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["bash"]