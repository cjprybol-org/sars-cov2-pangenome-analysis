# See here for image contents: https://hub.docker.com/r/jupyter/datascience-notebook/

FROM jupyter/datascience-notebook

# We want to run common-debian.sh from here:
# https://github.com/microsoft/vscode-dev-containers/tree/main/script-library#development-container-scripts
# But that script assumes that the main non-root user (in this case jovyan)
# is in a group with the same name (in this case jovyan).  So we must first make that so.
COPY .devcontainer/library-scripts/common-debian.sh /tmp/library-scripts/
USER root
RUN apt-get update \
 && groupadd jovyan \
 && usermod -g jovyan -a -G users jovyan \
 && bash /tmp/library-scripts/common-debian.sh \
 && apt-get clean -y && rm -rf /var/lib/apt/lists/* /tmp/library-scripts

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

# [Optional] Uncomment this section to install additional OS packages.
# RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
#     && apt-get -y install --no-install-recommends <your-package-list-here>

# set me to a specific tag when I'm ready to release this
RUN julia -e 'import Pkg; Pkg.add(url="https://github.com/cjprybol/Mycelia.git", rev="master")'
RUN julia -e 'import Pkg; Pkg.add("IJulia"); Pkg.build("IJulia")'

# https://snakemake.readthedocs.io/en/stable/getting_started/installation.html
# RUN conda install -c conda-forge mamba
RUN conda install -y -c conda-forge -c bioconda \
 snakemake \
 ncbi-datasets-cli \
 parallel
RUN curl https://rclone.org/install.sh | bash

# datasets download virus genome taxon SARS-CoV-2

USER jovyan

RUN mkdir -p /home/jovyan/.config/rclone/
COPY rclone.conf /home/jovyan/.config/rclone/rclone.conf

RUN echo "hello!"
