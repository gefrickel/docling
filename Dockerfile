FROM python:3.11-slim-bookworm

ENV GIT_SSH_COMMAND="ssh -o StrictHostKeyChecking=no"

RUN apt-get update \
    && apt-get install -y libgl1 libglib2.0-0 curl wget git procps \
    && rm -rf /var/lib/apt/lists/*

# This will install torch with *only* cpu support
# Remove the --extra-index-url part if you want to install all the gpu requirements
# For more details in the different torch distribution visit https://pytorch.org/.
RUN pip install --no-cache-dir docling --extra-index-url https://download.pytorch.org/whl/cpu

ENV HF_HOME=/tmp/
ENV TORCH_HOME=/tmp/

RUN MKDIR /app
RUN CHMOD 777 /app
COPY docs/examples/minimal.py /app/minimal.py

# RUN docling-tools models download
ENTRYPOINT ["/bin/sh", "-c", "--" , "while true; do sleep 30; done;"]
# On container environments, always set a thread budget to avoid undesired thread congestion.
ENV OMP_NUM_THREADS=4

# On container shell:
# > cd /root/
# > python minimal.py

# Running as `docker run -e DOCLING_ARTIFACTS_PATH=/root/.cache/docling/models` will use the
# model weights included in the container image.
