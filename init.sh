#!/usr/bin/env bash

if [[ ! -f "/install-complete" ]]; then
  conda run -n vicuna-matata /bin/bash -c "cd /text-generation-webui/repositories/GPTQ-for-LLaMa/ && python setup_cuda.py install"
  touch /install-complete
fi

echo "Running webserver.."

conda run -n vicuna-matata /bin/bash -c "cd /text-generation-webui/ && python server.py --model anon8231489123_vicuna-13b-GPTQ-4bit-128g --auto-devices --wbits 4 --groupsize 128 --chat --listen --extension api"
