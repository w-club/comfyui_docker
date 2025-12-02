FROM pytorch/pytorch:2.9.0-cuda13.0-cudnn9-runtime

RUN apt-get update && apt-get install -y git wget gosu libgl1 libglib2.0-0 build-essential ffmpeg libportaudio2 && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /workspace

RUN --mount=type=cache,target=/root/.cache/pip \
    wget https://raw.githubusercontent.com/comfyanonymous/ComfyUI/master/requirements.txt && \
    pip install -r requirements.txt && \
    wget https://raw.githubusercontent.com/Comfy-Org/ComfyUI-Manager/main/requirements.txt -O manager_requirements.txt && \
    pip install -r manager_requirements.txt && \
    wget https://raw.githubusercontent.com/Fannovel16/comfyui_controlnet_aux/main/requirements.txt -O controlnet_aux_reqs.txt && \
    pip install -r controlnet_aux_reqs.txt && \
    wget https://raw.githubusercontent.com/kijai/ComfyUI-KJNodes/main/requirements.txt -O kjnodes_reqs.txt && \
    pip install -r kjnodes_reqs.txt && \
    wget https://raw.githubusercontent.com/un-seen/comfyui-tensorops/main/requirements.txt -O tensorops_reqs.txt && \
    pip install -r tensorops_reqs.txt && \
    wget https://raw.githubusercontent.com/ltdrdata/was-node-suite-comfyui/refs/heads/main/requirements.txt -O was_reqs.txt && \
    pip install -r was_reqs.txt && \
    wget https://raw.githubusercontent.com/crystian/ComfyUI-Crystools/refs/heads/main/requirements.txt -O mon_reqs.txt && \
    pip install -r mon_reqs.txt && \
    wget https://raw.githubusercontent.com/fredconex/ComfyUI-SongBloom/refs/heads/main/requirements_chinese.txt -O sb_reqs.txt && \
    pip install -r sb_reqs.txt && \
    wget https://raw.githubusercontent.com/nicofdga/DZ-FaceDetailer/refs/heads/main/requirements.txt -O detailer_reqs.txt && \
    pip install -r detailer_reqs.txt && \
    pip install flask-restx py-cord[voice] browser-use && \
    pip install torchcodec && \
    pip install onnxruntime-gpu
    
RUN --mount=type=cache,target=/root/.cache/pip \
    wget https://raw.githubusercontent.com/heshengtao/comfyui_LLM_party/refs/heads/main/requirements_fixed.txt -O llm_reqs.txt && \
    pip install -r llm_reqs.txt &&

COPY entrypoint.sh /workspace/entrypoint.sh
RUN chmod u+x /workspace/entrypoint.sh

COPY run_comfy.sh /workspace/run_comfy.sh
RUN chmod u+x /workspace/run_comfy.sh

ENV NVIDIA_VISIBLE_DEVICES=all 
ENV PIP_USER=true
ENV PIP_ROOT_USER_ACTION=ignore
ENV PATH="/root/.local/bin:$PATH"
ENTRYPOINT ["/workspace/entrypoint.sh"]
CMD ["python", "-u", "/comfyui/main.py", "--listen", "0.0.0.0"]
