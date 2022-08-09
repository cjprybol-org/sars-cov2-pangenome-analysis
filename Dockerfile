# See here for image contents: https://hub.docker.com/r/jupyter/datascience-notebook/

FROM jupyter/datascience-notebook

USER root

RUN echo $HOME

ENV HOME=/user/root

 # [Optional] Uncomment this section to install additional OS packages.
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
    libfuse2 \
    fuse \
    graphviz

# [Optional] If your pip requirements rarely change, uncomment this section to add them to the image.
# COPY requirements.txt /tmp/pip-tmp/
# RUN pip3 --disable-pip-version-check --no-cache-dir install -r /tmp/pip-tmp/requirements.txt \
#    && rm -rf /tmp/pip-tmp

# set me to a specific tag when I'm ready to release this
RUN julia -e 'import Pkg; Pkg.add(url="https://github.com/cjprybol/Mycelia.git", rev="master")'
RUN julia -e 'import Pkg; Pkg.add("IJulia"); Pkg.build("IJulia")'

# https://snakemake.readthedocs.io/en/stable/getting_started/installation.html
RUN conda install -y -c conda-forge -c bioconda \
 snakemake \
 ncbi-datasets-cli \
 parallel
RUN curl https://rclone.org/install.sh | bash

RUN mkdir -p $HOME/.config/rclone/
COPY rclone.conf $HOME/.config/rclone/rclone.conf
