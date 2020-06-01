# Ubuntu is the base image
FROM ubuntu:20.04
ENV DEBIAN_FRONTEND noninteractive

# Update Ubuntu packages and install system dependencies and some tools I want
RUN cp /etc/apt/sources.list /etc/apt/sources.list~
RUN sed -Ei 's/^# deb-src /deb-src /' /etc/apt/sources.list
RUN apt-get update \
    && apt-get install -y pkg-config libfreetype6-dev build-essential libx11-dev neovim git wget bzip2 tree \
    && apt-get clean

# Add a user with no password
RUN adduser --disabled-password --gecos '' sisko
USER sisko
WORKDIR /home/sisko
RUN chmod a+rw /home/sisko
RUN git clone https://github.com/dewittpe/dotfiles
RUN cd dotfiles; bash ./init.sh

# Install Anaconda
RUN wget https://repo.anaconda.com/archive/Anaconda3-2020.02-Linux-x86_64.sh \
    && bash Anaconda3-2020.02-Linux-x86_64.sh -b \
    && rm Anaconda3-2020.02-Linux-x86_64.sh

# Set path to conda
ENV PATH /home/sisko/anaconda3/bin:$PATH

# Configure access to Jupyter
RUN mkdir /home/sisko/notebooks
RUN jupyter notebook --generate-config --allow-root

RUN echo "c.NotebookApp.password = u'sha1:6a3f528eec40:6e896b6e4828f525a6e20e5411cd1c8075d68619'" >> /home/sisko/.jupyter/jupyter_notebook_config.py

# Jupyter listens ot port 8888
EXPOSE 8888

# Make and move into a directory for *this* project
RUN mkdir /home/sisko/pdsh
WORKDIR /home/sisko/pdsh

COPY . .
RUN conda update conda \
    && conda update anaconda \
    && conda update --all \
    && conda env create -f environment.yml \
    && conda clean --all --yes

# Run Jupytewr notebook as Docker main process
#CMD ["jupyter", "notebook", "--allow-root", "--notebook-dir=/home/sisko/notebooks", "--ip='*'", "--port=8888", "--no-browser &"]

CMD ["bash"]
