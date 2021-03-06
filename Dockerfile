# This file is part of REANA.
# Copyright (C) 2017, 2018 CERN.
#
# REANA is free software; you can redistribute it and/or modify it
# under the terms of the MIT License; see LICENSE file for more details.

FROM python:3.6

ENV TERM=xterm
RUN apt-get update && \
    apt-get install -y vim-tiny && \
    pip install --upgrade pip

COPY CHANGES.rst README.rst setup.py /code/
COPY reana_job_controller/version.py /code/reana_job_controller/
WORKDIR /code
RUN pip install --no-cache-dir requirements-builder && \
    requirements-builder -e all -l pypi setup.py | pip install --no-cache-dir -r /dev/stdin && \
    pip uninstall -y requirements-builder

COPY . /code

# Debug off by default
ARG DEBUG=false

RUN if [ "${DEBUG}" = "true" ]; then pip install -r requirements-dev.txt; pip install -e .; else pip install .; fi;

EXPOSE 5000
CMD ["python", "reana_job_controller/app.py"]
