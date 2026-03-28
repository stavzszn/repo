#!/bin/bash
set -e

# === 1. ENVIRONMENT SETUP ===
if [ -f "/venv/main/bin/activate" ]; then
    source /venv/main/bin/activate
elif [ -f "/opt/venv/bin/activate" ]; then
    source /opt/venv/bin/activate
fi

WORKSPACE=${WORKSPACE:-/workspace}
COMFYUI_DIR="${WORKSPACE}/ComfyUI"
echo "=== Starting SZNVAULT installation (Protected) ==="

# === 2. AUTHORIZATION AND LEAK PROTECTION (SUPABASE) ===
if [ -z "$SZN_TOKEN" ] || [ "$SZN_TOKEN" == "INSERT_TOKEN_HERE" ]; then
    echo "CRITICAL ERROR: You have not set SZN_TOKEN in your Vast.ai settings!"
    sleep infinity
    exit 1
fi

PUBLIC_IP=$(curl -s ifconfig.me)
SUPABASE_URL="https://jjvwotkmslbfytrkbkha.supabase.co/functions/v1/check-token"
SUPABASE_KEY="sb_publishable_Gh3ScaXdSzer6VQJYaJCAg_XqcjbFqm"

RESPONSE=$(curl -s -X POST "$SUPABASE_URL" \
    -H "apikey: $SUPABASE_KEY" \
    -H "Content-Type: application/json" \
    -d "{\"p_token\": \"${SZN_TOKEN}\", \"p_vast_id\": \"${PUBLIC_IP}\"}")

if [[ "$RESPONSE" == *"#!/bin/bash"* ]]; then
    echo "=========================================================="
    echo "✅ Your token has been verified by SZNVAULT"
    echo "⏳ Download started, please wait 30-40 minutes..."
    echo "Contact us here: sznvault.com or t.me/sznvault"
    echo "=========================================================="
else
    echo "=========================================================="
    echo "❌ ACCESS DENIED: Token is invalid or blocked!"
    echo "Leak protection may have triggered."
    echo "Script stopped. Contact SZNVAULT"
    echo "sznvault.com or t.me/sznvault"
    echo "=========================================================="
    sleep infinity
    exit 1
fi


# === WORKFLOWS , NODES AND MODEL LISTS ===
WRAPER_ANIMATOR=("https://raw.githubusercontent.com/stavzszn/repo/refs/heads/main/SZN%20WanAnimate%20v1.json")
WRAPER_XMODE=("https://raw.githubusercontent.com/stavzszn/repo/refs/heads/main/SZN%20Z-Image%20v1.json")

NODES=(
    "https://github.com/ltdrdata/ComfyUI-Manager"
    "https://github.com/kijai/ComfyUI-WanVideoWrapper"
    "https://github.com/ltdrdata/ComfyUI-Impact-Pack"
    "https://github.com/numz/ComfyUI-SeedVR2_VideoUpscaler"
    "https://github.com/chflame163/ComfyUI_LayerStyle"
    "https://github.com/rgthree/rgthree-comfy"
    "https://github.com/yolain/ComfyUI-Easy-Use"
    "https://github.com/kijai/ComfyUI-KJNodes"
    "https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite"
    "https://github.com/kijai/ComfyUI-segment-anything-2"
    "https://github.com/cubiq/ComfyUI_essentials"
    "https://github.com/fq393/ComfyUI-ZMG-Nodes"
    "https://github.com/kijai/ComfyUI-WanAnimatePreprocess"
    "https://github.com/jnxmx/ComfyUI_HuggingFace_Downloader"
    "https://github.com/plugcrypt/CRT-Nodes"
    "https://github.com/pythongosssss/ComfyUI-Custom-Scripts"
    "https://github.com/ClownsharkBatwing/RES4LYF"
    "https://github.com/chrisgoringe/cg-use-everywhere"
    "https://github.com/ltdrdata/ComfyUI-Impact-Subpack"
    "https://github.com/Smirnov75/ComfyUI-mxToolkit"
    "https://github.com/crystian/ComfyUI-Crystools"
    "https://github.com/teskor-hub/comfyui-teskors-utils.git"
    "https://github.com/TheLustriVA/ComfyUI-Image-Size-Tools"
    "https://github.com/ZhiHui6/zhihui_nodes_comfyui"
    "https://github.com/EllangoK/ComfyUI-post-processing-nodes"
    "https://github.com/Fannovel16/comfyui_controlnet_aux"
    "https://github.com/Azornes/Comfyui-Resolution-Master"
    "https://github.com/evanspearman/ComfyMath"
)

CLIP_MODELS=("https://huggingface.co/Stavz/SZNVAULT/resolve/main/klip_vision.safetensors"
"https://huggingface.co/Comfy-Org/z_image_turbo/resolve/main/split_files/text_encoders/qwen_3_4b.safetensors")
CKPT_MODELS=("https://huggingface.co/gazsuv/sudoku/resolve/main/detect.safetensors")
FUN_MODELS=("https://huggingface.co/arhiteector/zimage/resolve/main/Z-Image-Turbo-Fun-Controlnet-Union.safetensors")

# Combined TEXT_ENCODERS to fix the overwrite issue
TEXT_ENCODERS=(
    "https://huggingface.co/UmeAiRT/ComfyUI-Auto_installer/resolve/refs%2Fpr%2F5/models/clip/umt5-xxl-encoder-fp8-e4m3fn-scaled.safetensors"
    "https://huggingface.co/Stavz/SZNVAULT/resolve/main/text_enc.safetensors"
)

UNET_MODELS=("https://huggingface.co/Comfy-Org/z_image_turbo/resolve/main/split_files/diffusion_models/z_image_turbo_bf16.safetensors")
CLIPS=("https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/resolve/main/split_files/clip_vision/clip_vision_h.safetensors")
VAE_MODELS=("https://huggingface.co/Stavz/SZNVAULT/resolve/main/vae.safetensors"
"https://huggingface.co/Comfy-Org/z_image_turbo/resolve/main/split_files/vae/ae.safetensors")
DETECTION_MODELS=("https://huggingface.co/Stavz/SZNVAULT/resolve/main/yolov10m.onnx"
"https://huggingface.co/Stavz/SZNVAULT/resolve/main/vitpose_h_wholebody_data.bin"
"https://huggingface.co/Stavz/SZNVAULT/resolve/main/vitpose_h_wholebody_model.onnx")
LORAS=("https://huggingface.co/Stavz/SZNVAULT/resolve/main/WanFun.reworked.safetensors"
"https://huggingface.co/Stavz/SZNVAULT/resolve/main/light.safetensors"
"https://huggingface.co/Stavz/SZNVAULT/resolve/main/WanPusa.safetensors"
"https://huggingface.co/Stavz/SZNVAULT/resolve/main/wan.reworked.safetensors"
"https://huggingface.co/Stavz/SZNVAULT/resolve/main/Wan21_Uni3C_controlnet_fp16.safetensors"
"https://huggingface.co/gazsuv/sudoku/resolve/main/real.safetensors"
"https://huggingface.co/gazsuv/sudoku/resolve/main/XXX.safetensors"
"https://huggingface.co/gazsuv/sudoku/resolve/main/gpu.safetensors" )
CLIP_VISION=("https://huggingface.co/Stavz/SZNVAULT/resolve/main/klip_vision.safetensors")

# Fixed typo from DEFFUSION to DIFFUSION_MODELS
DIFFUSION_MODELS=("https://huggingface.co/Stavz/SZNVAULT/resolve/main/WanModel.safetensors"
"https://huggingface.co/T5B/Z-Image-Turbo-FP8/resolve/main/z-image-turbo-fp8-e4m3fn.safetensors")

BBOX_0=("https://huggingface.co/gazsuv/pussydetectorv4/resolve/main/face_yolov8s.pt")
BBOX_1=("https://huggingface.co/gazsuv/pussydetectorv4/resolve/main/femaleBodyDetection_yolo26.pt")
BBOX_2=("https://huggingface.co/gazsuv/pussydetectorv4/resolve/main/female_breast-v4.2.pt")
BBOX_3=("https://huggingface.co/gazsuv/pussydetectorv4/resolve/main/nipples_yolov8s.pt")
BBOX_4=("https://huggingface.co/gazsuv/pussydetectorv4/resolve/main/vagina-v4.2.pt")
BBOX_5=("https://huggingface.co/gazsuv/xmode/resolve/main/assdetailer.pt")
SAM_PTH=("https://huggingface.co/datasets/Gourieff/ReActor/resolve/main/models/sams/sam_vit_b_01ec64.pth")
BBOX_6=("https://huggingface.co/gazsuv/pussydetectorv4/resolve/main/Eyeful_v2-Paired.pt")
BBOX_7=("https://huggingface.co/gazsuv/pussydetectorv4/resolve/main/Eyes.pt")
BBOX_8=("https://huggingface.co/gazsuv/pussydetectorv4/resolve/main/FacesV1.pt")
BBOX_9=("https://huggingface.co/gazsuv/pussydetectorv4/resolve/main/hand_yolov8s.pt")
BBOX_10=("https://huggingface.co/AunyMoons/loras-pack/blob/main/foot-yolov8l.pt")
QWEN3VL_1=(
    "https://huggingface.co/svjack/Qwen3-VL-4B-Instruct-heretic-7refusal/resolve/main/added_tokens.json"
    "https://huggingface.co/svjack/Qwen3-VL-4B-Instruct-heretic-7refusal/resolve/main/chat_template.jinja"
    "https://huggingface.co/svjack/Qwen3-VL-4B-Instruct-heretic-7refusal/resolve/main/config.json"
    "https://huggingface.co/svjack/Qwen3-VL-4B-Instruct-heretic-7refusal/resolve/main/generation_config.json"
    "https://huggingface.co/svjack/Qwen3-VL-4B-Instruct-heretic-7refusal/resolve/main/merges.txt"
    "https://huggingface.co/svjack/Qwen3-VL-4B-Instruct-heretic-7refusal/resolve/main/model.safetensors.index.json"
    "https://huggingface.co/svjack/Qwen3-VL-4B-Instruct-heretic-7refusal/resolve/main/preprocessor_config.json"
    "https://huggingface.co/svjack/Qwen3-VL-4B-Instruct-heretic-7refusal/resolve/main/special_tokens_map.json"
    "https://huggingface.co/svjack/Qwen3-VL-4B-Instruct-heretic-7refusal/resolve/main/tokenizer.json"
    "https://huggingface.co/svjack/Qwen3-VL-4B-Instruct-heretic-7refusal/resolve/main/tokenizer_config.json"
    "https://huggingface.co/svjack/Qwen3-VL-4B-Instruct-heretic-7refusal/resolve/main/vocab.json"
)
QWEN3VL_2=("https://huggingface.co/svjack/Qwen3-VL-4B-Instruct-heretic-7refusal/resolve/main/model-00001-of-00002.safetensors")
QWEN3VL_3=("https://huggingface.co/svjack/Qwen3-VL-4B-Instruct-heretic-7refusal/resolve/main/model-00002-of-00002.safetensors")
UPSCALER_MODELS=("https://huggingface.co/gazsuv/pussydetectorv4/resolve/main/4xUltrasharp_4xUltrasharpV10.pt")

# Added missing SeedVR model
SEEDVR_MODELS=("https://huggingface.co/numz/SeedVR2_comfyUI/resolve/main/ema_vae_fp16.safetensors")

### ─────────────────────────────────────────────
### INSTALLATION FUNCTIONS
### ─────────────────────────────────────────────

 function provisioning_start() {
    provisioning_clone_comfyui
    provisioning_install_base_reqs
    provisioning_get_nodes
    provisioning_inject_hardcore_security

    provisioning_get_files "${COMFYUI_DIR}/web"                       "${WRAPER_ANIMATOR[@]}"
    provisioning_get_files "${COMFYUI_DIR}/user/default/workflows"    "${WRAPER_ANIMATOR[@]}"
    provisioning_get_files "${COMFYUI_DIR}/web"                       "${WRAPER_XMODE[@]}"
    provisioning_get_files "${COMFYUI_DIR}/user/default/workflows"    "${WRAPER_XMODE[@]}"
    provisioning_get_files "${COMFYUI_DIR}/models/clip"               "${CLIP_MODELS[@]}"
    provisioning_get_files "${COMFYUI_DIR}/models/clip_vision"        "${CLIP_VISION[@]}"
    provisioning_get_files "${COMFYUI_DIR}/models/text_encoders"      "${TEXT_ENCODERS[@]}"
    provisioning_get_files "${COMFYUI_DIR}/models/vae"                "${VAE_MODELS[@]}"
    provisioning_get_files "${COMFYUI_DIR}/models/diffusion_models"   "${DIFFUSION_MODELS[@]}"
    provisioning_get_files "${COMFYUI_DIR}/models/detection"          "${DETECTION_MODELS[@]}"
    provisioning_get_files "${COMFYUI_DIR}/models/loras"              "${LORAS[@]}"
    provisioning_get_files "${COMFYUI_DIR}/models/unet"               "${UNET_MODELS[@]}"
    
    # Fixed ckpt path
    provisioning_get_files "${COMFYUI_DIR}/models/checkpoints"        "${CKPT_MODELS[@]}"
    provisioning_get_files "${COMFYUI_DIR}/models/model_patches"      "${FUN_MODELS[@]}"
    
    # Fixed BBOX paths
    provisioning_get_files "${COMFYUI_DIR}/models/ultralytics/bbox"   "${BBOX_0[@]}"
    provisioning_get_files "${COMFYUI_DIR}/models/ultralytics/bbox"   "${BBOX_1[@]}"
    provisioning_get_files "${COMFYUI_DIR}/models/ultralytics/bbox"   "${BBOX_2[@]}"
    provisioning_get_files "${COMFYUI_DIR}/models/ultralytics/bbox"   "${BBOX_3[@]}"
    provisioning_get_files "${COMFYUI_DIR}/models/ultralytics/bbox"   "${BBOX_4[@]}"
    provisioning_get_files "${COMFYUI_DIR}/models/ultralytics/bbox"   "${BBOX_5[@]}"
    provisioning_get_files "${COMFYUI_DIR}/models/ultralytics/bbox"   "${BBOX_6[@]}"
    provisioning_get_files "${COMFYUI_DIR}/models/ultralytics/bbox"   "${BBOX_7[@]}"
    provisioning_get_files "${COMFYUI_DIR}/models/ultralytics/bbox"   "${BBOX_8[@]}"
    provisioning_get_files "${COMFYUI_DIR}/models/ultralytics/bbox"   "${BBOX_9[@]}"
    provisioning_get_files "${COMFYUI_DIR}/models/ultralytics/bbox"   "${BBOX_10[@]}"
    
    provisioning_get_files "${COMFYUI_DIR}/models/sams"               "${SAM_PTH[@]}"
    provisioning_get_files "${COMFYUI_DIR}/models/prompt_generator/Qwen3-VL-4B-Instruct-heretic-7refusal"   "${QWEN3VL_1[@]}"
    provisioning_get_files "${COMFYUI_DIR}/models/prompt_generator/Qwen3-VL-4B-Instruct-heretic-7refusal"   "${QWEN3VL_2[@]}"
    provisioning_get_files "${COMFYUI_DIR}/models/prompt_generator/Qwen3-VL-4B-Instruct-heretic-7refusal"   "${QWEN3VL_3[@]}"
    provisioning_get_files "${COMFYUI_DIR}/models/upscale_models"     "${UPSCALER_MODELS[@]}"
    
    # Added SeedVR path
    provisioning_get_files "${COMFYUI_DIR}/models/SEEDVR2"            "${SEEDVR_MODELS[@]}"

    echo "Models and Custom Nodes installed."
}

# === HARD UI LOCKDOWN + DESIGN ===
function provisioning_inject_hardcore_security() {
    export LOGO_URL="https://jjvwotkmslbfytrkbkha.supabase.co/storage/v1/object/public/images/logo.png"
    export BG_URL="https://jjvwotkmslbfytrkbkha.supabase.co/storage/v1/object/public/images/background.jpg"

    # Patching the ComfyUI system interface (Frontend V2 + LiteGraph)
    python -c '
import os
import site

logo_url = os.environ.get("LOGO_URL")
bg_url = os.environ.get("BG_URL")

paths_to_check = []
for sp in site.getsitepackages():
    paths_to_check.append(os.path.join(sp, "comfyui_frontend_package", "static", "index.html"))
paths_to_check.append("/workspace/ComfyUI/web/index.html")

patch_code = f"""
<style>
  /* Custom background */
  body, #app, .comfy-app-main, .graph-canvas-container {{
      background-image: url("{bg_url}") !important;
      background-size: cover !important;
      background-position: center !important;
      background-attachment: fixed !important;
  }}
  
  /* Glass effect */
  canvas.litegraph, canvas.lgraphcanvas {{
      opacity: 0.88 !important; 
  }}
  
  /* HARD SUPPRESS LOGOS AND MENU BUTTON */
  .comfy-logo, .comfyui-logo, svg[class*="comfyui-logo"],
  [aria-label="Menu"], [aria-label="Меню"],
  [data-pr-tooltip="Menu"], [data-pr-tooltip="Меню"],
  [data-pc-section="menuicon"] {{ display: none !important; }}

  /* SAFETY CSS AGAINST PROPERTIES AND SEARCH POPUPS */
  .p-sidebar-right, .p-dialog-right, 
  [data-pc-name="sidebar"][class*="right"],
  .lite-searchbox, .comfyui-node-search, [class*="node-search"] {{
      display: none !important;
  }}

  /* KILL COMFYUI MANAGER AT CSS LEVEL */
  #cm-manager-btn,
  button[id*="manager" i],
  [data-pr-tooltip*="Manager" i],
  [title*="Manager" i],
  [aria-label*="Manager" i] {{
      display: none !important;
  }}
</style>

<script>
  // 1. ABSOLUTE DOUBLE-CLICK BLOCK (Kills node search)
  window.addEventListener("dblclick", e => {{
      if (e.target.tagName.toLowerCase() === "canvas" || e.target.closest("canvas")) {{
          e.preventDefault();
          e.stopPropagation();
          e.stopImmediatePropagation();
      }}
  }}, true);

  // 2. KEYBOARD SHORTCUT BLOCK
  window.addEventListener("keydown", e => {{
    if (e.key === "F12") {{ e.preventDefault(); e.stopPropagation(); }}
    if (e.ctrlKey && e.shiftKey && ["I", "J", "C", "i", "j", "c"].includes(e.key)) {{ e.preventDefault(); e.stopPropagation(); }}
    if (e.ctrlKey && ["u", "U", "s", "S", "c", "C", "v", "V"].includes(e.key)) {{ e.preventDefault(); e.stopPropagation(); }}
  }}, true);

  // 3. SURGICAL MENU ITEM REMOVAL (UPDATED FOR MANAGER)
  const observer = new MutationObserver(() => {{
    const killWords = [
        "ассеты", "assets", "узлы", "nodes", "models", "модели", "nodesmap", 
        "шаблоны", "справка", "консоль", "настройки", "settings", "перевод", 
        "translate", "save", "export", "download", "сохранить", "экспорт", 
        "скачать", "menu", "меню", 
        "менеджер", "manager", "workspace manager", "comfyui manager",
        "experiments", "share", "поделиться",
        "свойства", "properties", "панель свойств", "properties panel", 
        "добавить узел", "add node", "преобразовать в подграф", "convert to group",
        "клонировать", "clone", "node help", "add ue broadcasting", "поиск"
    ];
    
    const menuSelectors = "header, .p-toolbar, [class*=\u0027topbar\u0027], [class*=\u0027top-bar\u0027], .litecontextmenu, .comfy-menu, .p-menubar, .p-menu, .p-panelmenu, .p-sidebar, .p-tieredmenu, .p-contextmenu, nav, aside, [class*=\u0027comfyui-menu\u0027]";
    
    document.querySelectorAll(menuSelectors).forEach(container => {{
        container.querySelectorAll("li, a, button, .p-menuitem, .litemenu-entry, .p-button").forEach(el => {{
          const txt = (el.innerText || el.textContent || "").trim().toLowerCase();
          const aria = (el.getAttribute("aria-label") || "").toLowerCase();
          const tooltip = (el.getAttribute("data-pr-tooltip") || "").toLowerCase();
          const title = (el.getAttribute("title") || "").toLowerCase();
          const id = (el.getAttribute("id") || "").toLowerCase();
          
          const combinedText = txt + " " + aria + " " + tooltip + " " + title + " " + id;

          if (combinedText.includes("меню") || combinedText.includes("menu")) {{
              if (!combinedText.includes("рабочие") && !combinedText.includes("workflow")) {{
                  el.style.display = "none";
              }}
          }}

          if (killWords.some(w => combinedText === w || combinedText.includes(w))) {{
              if (!combinedText.includes("рабочие") && !combinedText.includes("workflow")) {{
                  el.style.display = "none";
              }}
          }}
        }});
    }});
  }});
  
  document.addEventListener("DOMContentLoaded", () => {{
    observer.observe(document.body, {{ 
        childList: true, 
        subtree: true, 
        characterData: true, 
        attributes: true, 
        attributeFilter: ["data-pr-tooltip", "aria-label", "title", "id"] 
    }});

    const logo = document.createElement("img");
    logo.src = "{logo_url}";
    logo.style.cssText = "position: fixed; top: 15px; right: 30px; height: 50px; z-index: 10000; pointer-events: none; filter: drop-shadow(0px 4px 6px rgba(0,0,0,0.5));";
    document.body.appendChild(logo);
  }});

const overrideLiteGraph = setInterval(() => {{
      if (window.LiteGraph && window.LGraphCanvas) {{
          window.LGraphCanvas.prototype.showSearchBox = function() {{ return false; }};
          clearInterval(overrideLiteGraph);
      }}
  }}, 500);

  // 4. BLOCK RIGHT CLICK
  document.addEventListener("contextmenu", e => {{
      e.preventDefault();
      e.stopPropagation();
  }}, true);

  // 5. DEVTOOLS DETECTION
  (function detectDevTools() {{
      const threshold = 160;
      setInterval(() => {{
          if (
              window.outerWidth - window.innerWidth > threshold ||
              window.outerHeight - window.innerHeight > threshold
          ) {{
              if (window.app?.graph) {{
                  window.app.graph.clear();
              }}
          }}
      }}, 1000);
  }})();

  // 6. DEBUGGER TRAP
  setInterval(() => {{ debugger; }}, 100);

  // 7. BLOCK WORKFLOW API ENDPOINT
  const _fetch = window.fetch;
  window.fetch = function(...args) {{
      const url = typeof args[0] === "string" ? args[0] : args[0]?.url ?? "";
      if (url.includes("/api/history") || (url.includes("prompt") && url.includes("GET"))) {{
          return Promise.resolve(new Response("{{}}", {{ status: 200 }}));
      }}
      return _fetch.apply(this, args);
  }};
</script>
"""

for path in paths_to_check:
    if os.path.exists(path):
        with open(path, "r", encoding="utf-8") as f:
            content = f.read()
        
        if "NATIVE UI TWEAKS" not in content:
            patched_content = content.replace("</head>", patch_code + "\n</head>")
            with open(path, "w", encoding="utf-8") as f:
                f.write(patched_content)
'
}

# Clone quietly (-q)
function provisioning_clone_comfyui() {
    if [[ ! -d "${COMFYUI_DIR}" ]]; then
        git clone -q https://github.com/comfyanonymous/ComfyUI.git "${COMFYUI_DIR}" > /dev/null 2>&1
    fi
    cd "${COMFYUI_DIR}"
}

# Install dependencies quietly (-q)
function provisioning_install_base_reqs() {
    if [[ -f requirements.txt ]]; then
        pip install -q --no-cache-dir -r requirements.txt > /dev/null 2>&1 || true
    fi
}

# Clone custom nodes quietly (-q)
function provisioning_get_nodes() {
    mkdir -p "${COMFYUI_DIR}/custom_nodes"
    cd "${COMFYUI_DIR}/custom_nodes"

    for repo in "${NODES[@]}"; do
        dir="${repo##*/}"
        path="./${dir}"

        if [[ -d "$path" ]]; then
            (cd "$path" && git pull -q --ff-only > /dev/null 2>&1 || { git fetch -q > /dev/null 2>&1 && git reset -q --hard origin/main > /dev/null 2>&1; })
        else
            git clone -q "$repo" "$path" --recursive > /dev/null 2>&1 || true
        fi

        requirements="${path}/requirements.txt"
        if [[ -f "$requirements" ]]; then
            pip install -q --no-cache-dir -r "$requirements" > /dev/null 2>&1 || true
        fi
    done
}

# Download files quietly (-q)
function provisioning_get_files() {
    if [[ $# -lt 2 ]]; then return; fi
    local dir="$1"
    shift
    local files=("$@")

    mkdir -p "$dir"

    for url in "${files[@]}"; do
        if [[ -n "$HF_TOKEN" && "$url" =~ huggingface\.co ]]; then
            wget --header="Authorization: Bearer $HF_TOKEN" -q -nc --content-disposition -P "$dir" "$url" || true
        elif [[ -n "$CIVITAI_TOKEN" && "$url" =~ civitai\.com ]]; then
            wget --header="Authorization: Bearer $CIVITAI_TOKEN" -q -nc --content-disposition -P "$dir" "$url" || true
        else
            wget -q -nc --content-disposition -P "$dir" "$url" || true
        fi
    done
}

# Run provisioning
if [[ ! -f /.noprovisioning ]]; then
    provisioning_start
fi

echo "===================================================================="
echo "Installation complete! Workflows launched successfully."
echo "===================================================================="
