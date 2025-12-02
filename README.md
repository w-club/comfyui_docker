# ComfyUI in Docker (Personal Experiment)

This is a personal, Docker-based experimental environment for ComfyUI.
It utilizes a high-performance base image with **PyTorch 2.9.1** and CUDA 13.0, pre-integrated with essential and powerful custom nodes. This build is specifically optimized to resolve complex dependency conflicts (Dependency Hell), providing an out-of-the-box experience.

## 📦 Core Components

* **[ComfyUI](https://github.com/comfyanonymous/ComfyUI)**: The most powerful and modular Stable Diffusion GUI.
* **[ComfyUI-Manager](https://github.com/Comfy-Org/ComfyUI-Manager)**: An essential extension designed to enhance the usability of ComfyUI, allowing for easy installation and management of custom nodes and models.
* **[Pytorch Docker Image](https://hub.docker.com/layers/pytorch/pytorch/2.9.1-cuda13.0-cudnn9-runtime/images/sha256-1ba3f20399f5e4f9835cde308a4de86c3e63ba098caee367e490ec5455afc02a)**: Base environment running **PyTorch 2.9.1** with CUDA 13.0 runtime.

## 🧩 Pre-installed Custom Nodes

The following nodes are pre-installed, and their dependencies have been manually patched to ensure stability:

* **[comfyui_controlnet_aux](https://github.com/Fannovel16/comfyui_controlnet_aux)**: Comprehensive set of preprocessors for ControlNet.
* **[ComfyUI-KJNodes](https://github.com/kijai/ComfyUI-KJNodes)**: A suite of useful utility nodes for various workflows.
* **[comfyui-tensorops](https://github.com/un-seen/comfyui-tensorops)**: Tools for advanced tensor operations.
* **[was-node-suite-comfyui](https://github.com/WASasquatch/was-node-suite-comfyui)**: An extensive node suite containing image processing and auxiliary tools.
* **[ComfyUI-Crystools](https://github.com/crystian/ComfyUI-Crystools)**: Hardware monitoring (VRAM/RAM/GPU usage) and metadata readers.
* **[DZ-FaceDetailer](https://github.com/nicofdga/DZ-FaceDetailer)**: Essential tool for face restoration and detailing.
* **[comfyui_LLM_party](https://github.com/heshengtao/comfyui_LLM_party)**: Integration for Large Language Models (OpenAI, Claude, etc.).
  * *Note: The `aisuite` dependency has been modified to use the core package to avoid conflicts with Google Cloud SDKs.*

## 🚀 Quick Start

Use Docker Compose to spin up the service.

### docker-compose.yaml

```yaml
services:
  comfyui:
    # Always use the latest stable build
    image: wclu6/comfyui_docker:latest
    container_name: comfyui
    ports:
      - 8188:8188
    volumes:
      # Map the ComfyUI core directory (Optional: disable if you want to keep the container's version)
      - ./comfyui:/comfyui
      # Models storage (Checkpoints, Loras, VAEs, etc.)
      - ./ai/models:/comfyui/models
      # Output directory for generated images
      - ./ai/output:/comfyui/output
      # Input directory for source images
      - ./ai/input:/comfyui/input
      # User directory for custom settings and workflows
      - ./ai/user:/comfyui/user
    deploy:
      resources:
        reservations:
          devices:
            - capabilities:
                - gpu
    environment:
      - NVIDIA_VISIBLE_DEVICES=all
      # Set to 'true' for multi-user mode, or 'false' for single user. Configurable.
      - MULTI_USER=true
    restart: unless-stopped
