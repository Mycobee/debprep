FROM debian:stable-slim

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ansible \
    bash \
    python-is-python3 \
    python3 && \
    rm -rf /var/lib/apt/lists/*

RUN eval "$(ssh-agent -s)"

COPY . /debprep

SHELL ["/bin/bash", "-c"]

WORKDIR /debprep
