# comfyui_in_docker
personal docker experiment

[ComfyUI](https://github.com/comfyanonymous/ComfyUI)

[Pytorch](https://hub.docker.com/layers/pytorch/pytorch/2.9.0-cuda13.0-cudnn9-runtime/images/sha256-1ba3f20399f5e4f9835cde308a4de86c3e63ba098caee367e490ec5455afc02a)

docker compose
```yaml
services:
  comfyui:
    image: wclu6/comfyui_docker:init
    container_name: comfyui
    ports:
      - 8188:8188
    volumes:
      - ./comfyui:/comfyui
      - ./ai/models:/comfyui/models
      - ./ai/output:/comfyui/output
      - ./ai/input:/comfyui/input
      - ./ai/user:/comfyui/user
    deploy:
      resources:
        reservations:
          devices:
            - capabilities:
                - gpu
    environment:
      - NVIDIA_VISIBLE_DEVICES=all
      - MULTI_USER=true
    restart: unless-stopped
networks: {}
```
