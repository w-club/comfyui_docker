#!/bin/bash

PUID=${PUID:-1000}
PGID=${PGID:-1000}
USER_NAME="appuser"
USER_HOME="/home/${USER_NAME}"
COMFY="/comfyui"
COMFY_GIT="https://github.com/comfyanonymous/ComfyUI.git"
C_M_GIT="https://github.com/ltdrdata/ComfyUI-Manager.git"
MULTI_USER=${MULTI_USER:-false}
USER_DATA_DIR="${COMFY}/user"
RUN_ARGS="--listen 0.0.0.0 --port 8188"

# Check if ComfyUI is installed
if [ -f "${COMFY}/main.py" ]; then
  echo "ComfyUI is already installed."
else
  echo "ComfyUI not found, installing..."
  git clone ${COMFY_GIT} ${COMFY}
fi

# Check if ComfyUI-Manager is installed
if [ -d "${COMFY}/custom_nodes/comfyui-manager" ]; then
  echo "ComfyUI-Manager is already installed."
else
  git clone ${C_M_GIT} ${COMFY}/custom_nodes/comfyui-manager
  echo "ComfyUI-Manager installed successfully."
fi

# Single or Multi user
RUN_ARGS="${RUN_ARGS} --user-directory ${USER_DATA_DIR}"

if [ "$MULTI_USER" = "true" ]; then
    RUN_ARGS="${RUN_ARGS} --multi-user"
    echo "Starting ComfyUI in MULTI-USER mode."
else
    echo "Starting ComfyUI in SINGLE-USER mode."
fi

# Set permissions for the /comfyui directory
chown -R ${PUID}:${PGID} ${COMFY}

# Start the ComfyUI service as APPUSER
exec gosu ${PUID}:${PGID} python -u ${COMFY}/main.py ${RUN_ARGS}
