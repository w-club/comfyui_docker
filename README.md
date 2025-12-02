# [w-club/comfyui_docker](https://github.com/w-club/comfyui_docker)

This is a personal, Docker-based experimental environment for **ComfyUI**.  
It utilizes a high-performance base image with **PyTorch 2.9.1** and **CUDA 13.0**, pre-integrated with essential and powerful custom node dependencies.  

This build is specifically optimized to resolve complex dependency conflicts (“dependency hell”), providing an **out-of-the-box** experience.

---

## 📋 Prerequisites

Before running this container, ensure your host machine meets the following requirements:

- **NVIDIA GPU** with up-to-date drivers installed 
- **Docker** and **Docker Compose** installed  
- **NVIDIA Container Toolkit** installed and configured  
  - This is **strictly required** for the container to access your GPU.  
  - [NVIDIA Container Toolkit – Install Guide](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html)

---

## 📦 Core Components

### [ComfyUI](https://github.com/comfyanonymous/ComfyUI)
The most powerful and modular Stable Diffusion GUI.

### [ComfyUI-Manager](https://github.com/Comfy-Org/ComfyUI-Manager)
Essential extension for managing custom nodes and models directly from the UI.

### [PyTorch Docker Image](https://hub.docker.com/r/pytorch/pytorch)
Base environment running **PyTorch 2.9.1** with **CUDA 13.0** runtime.

---

## 🧩 Pre-installed Requirements for Custom Nodes

> **Important**  
> This Docker image pre-installs the heavy Python dependencies (requirements) for the following nodes to ensure stability and avoid build errors (such as `rsa` or `google-cloud` conflicts).  
>  
> You still need to **search for and install these nodes themselves** via **ComfyUI-Manager inside the UI** to complete the setup.

Pre-resolved Python requirements are included for:

- **[comfyui_controlnet_aux](https://github.com/Fannovel16/comfyui_controlnet_aux)**  
  Comprehensive set of preprocessors for ControlNet.

- **[ComfyUI-KJNodes](https://github.com/kijai/ComfyUI-KJNodes)**  
  A suite of useful utility nodes for various workflows.

- **[comfyui-tensorops](https://github.com/un-seen/comfyui-tensorops)**  
  Tools for advanced tensor operations.

- **[was-node-suite-comfyui](https://github.com/WASasquatch/was-node-suite-comfyui)**  
  Extensive node suite for image processing and auxiliary tools.

- **[ComfyUI-Crystools](https://github.com/crystian/ComfyUI-Crystools)**  
  Hardware monitoring (VRAM/RAM/GPU usage) and metadata readers.

- **[DZ-FaceDetailer](https://github.com/nicofdga/DZ-FaceDetailer)**  
  Essential tool for face restoration and detailing.

- **[comfyui_LLM_party](https://github.com/heshengtao/comfyui_LLM_party)**  
  Integration for Large Language Models (OpenAI, Claude, etc.).

> **Note**  
> The `aisuite` dependency has been modified to use the **core package** instead of the full `aisuite[all]` variant to avoid conflicts with Google Cloud SDKs.

---

## 📂 Suggested Host Folder Structure

You can organize your host machine like this:

```text
.
├── docker-compose.yml
├── comfyui/          # ComfyUI core from container
└── ai/
    ├── models/       # Models: checkpoints, LoRA, VAE, etc.
    ├── output/       # Generated images
    ├── input/        # Source images / assets
    └── user/         # Workflows, custom configs, user data
```
These paths are mapped into the container via Docker volumes (see below).

---

## 🚀 Quick Start

Use **Docker Compose** to spin up the service.

### `docker-compose.yaml`

```yaml
services:
  comfyui:
    # Always use the latest stable build
    image: wclu6/comfyui_docker:latest
    container_name: comfyui

    ports:
      - "8188:8188"

    volumes:
      # Map the ComfyUI core directory
      - ./comfyui:/comfyui

      # Models storage (Checkpoints, LoRAs, VAEs, etc.)
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
```

### 🚀 Launch Command

Run the following command in your terminal:

```bash
docker compose up -d
```

Once started, access the interface at:
```
http://localhost:8188
```
## 🛠️ Build Information

This image has been customized to address specific dependency issues found in **comfyui_LLM_party** and several heavy third-party libraries.

### Dependency Fix

- Switched `aisuite[all]` → **`aisuite` core package**
- Avoids version conflicts involving:
  - `rsa`
  - `google-auth`
  - `google-cloud-*`
- Ensures a successful build and more stable runtime.

---

## 🔍 Notes & Requirements

- **Required:** NVIDIA drivers and `nvidia-container-toolkit` **must** be correctly installed on the host, otherwise GPU access will not work.
- **Required:** The `./comfyui:/comfyui` bind mount **must** be present for this setup, as the container expects ComfyUI to live at `/comfyui` inside the container.
- You can still install additional custom nodes via **ComfyUI-Manager** inside the UI.
- Ensure you have enough VRAM for your chosen models and workflows.
