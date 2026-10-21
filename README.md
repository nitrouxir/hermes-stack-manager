# Hermes Stack Manager

[![Version](https://img.shields.io/badge/version-v2.0.0-blue.svg)](https://github.com/faradoros/hermes-stack-manager)
[![Project](https://img.shields.io/badge/ecosystem-Nitroux-indigo.svg)](https://nitroux.ir)
[![Platform](https://img.shields.io/badge/platform-Windows%20%7C%20macOS-brightgreen.svg)](#)

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
  - **Cross-Platform (macOS & Windows)**: Tkinter-based control panel (`HermesManager.py`).
- ⚡ **One-Click Automated Setup**:
  - `Install-HermesStack.ps1` automatically verifies/installs Git, Node.js, Python, uv, 9Router, Hermes Agent, and Hermes WebUI.
  - Automatically provisions configuration and desktop shortcuts.
- 🔄 **Service Lifecycle Management**:
  - `start.ps1` — Launches 9Router (port 20128) and Hermes WebUI (port 8787).
  - `stop.ps1` — Gracefully stops all active stack services and lingering ports.
  - `status.ps1` — Real-time health check of stack ports and endpoints.
  - `update.ps1` — Seamless one-click updater for Agent, WebUI repo, and dependencies.

---

## 🚀 Quick Start

### 1. Automated Installation (Windows)
Run PowerShell as Administrator or with standard privileges and execute:
```powershell
powershell -ExecutionPolicy Bypass -File .\Install-HermesStack.ps1
```

### 2. Launch the Control Center
- **Windows**: Double-click `Run-Manager.bat` or run:
  ```powershell
  powershell -ExecutionPolicy Bypass -File .\HermesManager.ps1
  ```
- **macOS / Linux / Windows (Python GUI)**:
  ```bash
  python HermesManager.py
  ```

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
- **GitHub Repository**: [github.com/faradoros/hermes-stack-manager](https://github.com/faradoros/hermes-stack-manager)

---

## 📄 License
Released under the [MIT License](LICENSE).
Part of the **Nitroux** project.
