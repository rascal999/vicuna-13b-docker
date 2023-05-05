FROM nvidia/cuda:11.7.0-devel-ubuntu22.04
SHELL ["/bin/bash", "-c"]

RUN apt update && apt install -y python3 curl git g++

### Conda
# Install our public GPG key to trusted store
RUN curl https://repo.anaconda.com/pkgs/misc/gpgkeys/anaconda.asc | gpg --dearmor > conda.gpg
RUN install -o root -g root -m 644 conda.gpg /usr/share/keyrings/conda-archive-keyring.gpg

# Check whether fingerprint is correct (will output an error message otherwise)
RUN gpg --keyring /usr/share/keyrings/conda-archive-keyring.gpg --no-default-keyring --fingerprint 34161F5BF5EB1D4BFBBB8F0A8AEB4F8B29D82806

# Add our Debian repo
RUN echo "deb [arch=amd64 signed-by=/usr/share/keyrings/conda-archive-keyring.gpg] https://repo.anaconda.com/pkgs/misc/debrepo/conda stable main" > /etc/apt/sources.list.d/conda.list

RUN apt update
RUN apt install conda
ENV PATH /opt/conda/bin:$PATH

### Vicuna
RUN conda create -n vicuna-matata pytorch torchvision torchaudio pytorch-cuda=11.7 cuda-toolkit -c 'nvidia/label/cuda-11.7.0' -c pytorch -c nvidia
SHELL ["conda","run","-n","vicuna-matata","/bin/bash","-c"]

RUN git clone https://github.com/oobabooga/text-generation-webui
RUN cd /text-generation-webui && pip install -r requirements.txt

### Download model
RUN cd /text-generation-webui && python download-model.py anon8231489123/vicuna-13b-GPTQ-4bit-128g

RUN mkdir -p /text-generation-webui/repositories && cd text-generation-webui/repositories && git clone https://github.com/oobabooga/GPTQ-for-LLaMa.git -b cuda
RUN cd /text-generation-webui/repositories/GPTQ-for-LLaMa && pip install -r requirements.txt 

COPY init.sh /

SHELL ["/bin/bash","-c"]

ENTRYPOINT /init.sh
