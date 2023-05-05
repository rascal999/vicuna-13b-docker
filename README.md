# vicuna-13b-docker

https://huggingface.co/anon8231489123/vicuna-13b-GPTQ-4bit-128g/discussions/34

## Build

```
docker build . -t v13b
```

## Run

```
docker run -p 5000:5000 -p 5005:5005 -p 7860:7860 --gpus all -it v13b
```
