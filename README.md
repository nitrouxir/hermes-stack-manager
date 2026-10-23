# Hermes Stack Manager

[![Version](https://img.shields.io/badge/version-v2.0.0-blue.svg)](https://github.com/nitrouxir/hermes-stack-manager/releases)
[![Project](https://img.shields.io/badge/ecosystem-Nitroux-indigo.svg)](https://nitroux.ir)
[![Platform](https://img.shields.io/badge/platform-Windows%20%7C%20macOS-brightgreen.svg)](#)
[![License](https://img.shields.io/badge/license-MIT-orange.svg)](LICENSE)

---

### 🌐 Language / زبان‌ها:
👉 **[🇮🇷 مطالعه راهنمای کامل نصب و راه‌اندازی به زبان فارسی](README.fa.md)**  
👉 **[🇬🇧 English Documentation](#-about-the-project)**

---

## 🇮🇷 راهنمای سریع نصب و اجرا (فارسی)

<div dir="rtl">

### مراحل راه‌اندازی روی ویندوز (Windows):
1. **دانلود پروژه:** `git clone https://github.com/nitrouxir/hermes-stack-manager.git`
2. **نصب خودکار:** اجرای `powershell -ExecutionPolicy Bypass -File .\Install-HermesStack.ps1`
3. **اجرای پنل:** دابل‌کلیک روی `Run-Manager.bat` و کلیک روی **Start Stack** (آدرس: `http://localhost:8787`).

### مراحل راه‌اندازی روی مک (macOS):
1. **دانلود پروژه:** `git clone https://github.com/nitrouxir/hermes-stack-manager.git && cd hermes-stack-manager`
2. **نصب خودکار:** اجرای `bash install-mac.sh`
3. **اجرای پنل:** اجرای `python3 HermesManager.py` (یا دابل‌کلیک روی `Run-Manager.command`).

👉 برای مطالعه جزئیات کامل، **[راهنمای فارسی کامل (README.fa.md)](README.fa.md)** را مشاهده کنید.

</div>

---

## 📖 About the Project

> **Hermes Stack Manager** is an all-in-one Desktop GUI Control Center, Automated Installer, and Service Manager for the Hermes AI ecosystem (**Hermes Agent**, **Hermes WebUI**, and **9Router**).
> 
> Developed under the **[Nitroux](https://nitroux.ir)** AI Platform initiative.

---

## 🌐 Nitroux Ecosystem
This project is part of **Nitroux** AI infrastructure and developer tools.  
For documentation, tutorials, resources, and community updates, visit:  
👉 **[https://nitroux.ir](https://nitroux.ir)**

---

## ✨ Features

- 🖥️ **Modern Desktop GUI**:
  - **Windows (WPF / XAML)**: Native dark slate interface (`HermesManager.ps1` / `Run-Manager.bat`).
  - **Cross-Platform (macOS & Windows)**: Tkinter-based control panel (`HermesManager.py` / `Run-Manager.command`).
- ⚡ **One-Click Automated Setup**:
  - `Install-HermesStack.ps1` (Windows) & `install-mac.sh` (macOS).
  - Automatically verifies/installs Git, Node.js, Python, uv, 9Router, Hermes Agent, and Hermes WebUI.
  - Automatically provisions configuration, API routing, and desktop shortcuts.
- 🔄 **Service Lifecycle Management**:
  - `start.ps1` / `start.sh` — Launches 9Router (port 20128) and Hermes WebUI (port 8787).
  - `stop.ps1` — Gracefully stops all active stack services and lingering ports.
  - `status.ps1` — Real-time health check of stack ports and endpoints.
  - `update.ps1` — Seamless one-click updater for Agent, WebUI repo, and dependencies.

---

## 🚀 Quick Start (English)

### Option A: Windows Setup
```powershell
# 1. Clone
git clone https://github.com/nitrouxir/hermes-stack-manager.git
cd hermes-stack-manager

# 2. Automated Install
powershell -ExecutionPolicy Bypass -File .\Install-HermesStack.ps1

# 3. Launch GUI
powershell -ExecutionPolicy Bypass -File .\HermesManager.ps1
# or double-click Run-Manager.bat
```

### Option B: macOS Setup
```bash
# 1. Clone
git clone https://github.com/nitrouxir/hermes-stack-manager.git
cd hermes-stack-manager

# 2. Automated Install
bash install-mac.sh

# 3. Launch GUI
python3 HermesManager.py
# or double-click Run-Manager.command
```

### Access Services
- **Hermes WebUI**: `http://localhost:8787`
- **9Router API Proxy**: `http://localhost:20128`

---

## 🛠️ Stack Architecture

| Component | Default Port | Description |
|-----------|--------------|-------------|
| **Hermes WebUI** | `8787` | Interactive browser-based chat & workspace interface |
| **9Router** | `20128` | Local AI router & proxy compatible with OpenAI format |
| **Hermes Agent** | CLI | Autonomous AI agent runtime |

---

## 🔗 Links & Resources
- **Website & Portal**: [nitroux.ir](https://nitroux.ir)
- **GitHub Repository**: [github.com/nitrouxir/hermes-stack-manager](https://github.com/nitrouxir/hermes-stack-manager)
- **Persian Documentation**: [README.fa.md](README.fa.md)

---

## 📄 License
Released under the [MIT License](LICENSE).
Part of the **Nitroux** project.
