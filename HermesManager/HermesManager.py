#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Hermes AI Stack - Cross-Platform Desktop Control Center (macOS & Windows)
GUI Manager for Hermes Agent, Hermes WebUI, 9Router, and OmniRoute
"""

import sys
import os
import platform
import socket
import subprocess
import webbrowser
import threading
import time

try:
    import tkinter as tk
    from tkinter import ttk, messagebox
except ImportError:
    print("Tkinter is required. On macOS, install with: brew install python-tk")
    sys.exit(1)

IS_MAC = platform.system() == "Darwin"
IS_WIN = platform.system() == "Windows"

# Color Palette (Modern Dark Slate)
BG_COLOR = "#0B132B"
CARD_BG = "#1C2541"
CARD_BORDER = "#3A506B"
TEXT_MAIN = "#F8FAFC"
TEXT_MUTED = "#94A3B8"
ACCENT_GREEN = "#10B981"
ACCENT_RED = "#EF4444"
ACCENT_BLUE = "#0EA5E9"
ACCENT_PURPLE = "#8B5CF6"
BTN_TEXT = "#FFFFFF"

def check_port(port):
    """Check if a TCP port is listening on localhost."""
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.settimeout(0.4)
    try:
        s.connect(("127.0.0.1", port))
        s.close()
        return True
    except (socket.timeout, ConnectionRefusedError, OSError):
        return False

def open_url(url):
    webbrowser.open(url)

def kill_port(port):
    """Stop process listening on specific port."""
    if IS_MAC:
        cmd = f"lsof -ti :{port} | xargs kill -9 2>/dev/null || true"
        subprocess.run(cmd, shell=True)
    elif IS_WIN:
        ps_cmd = f"Get-NetTCPConnection -LocalPort {port} -ErrorAction SilentlyContinue | Select-Object -ExpandProperty OwningProcess -Unique | ForEach-Object {{ if ($_ -gt 0) {{ Stop-Process -Id $_ -Force -ErrorAction SilentlyContinue }} }}"
        subprocess.run(["powershell", "-Command", ps_cmd], creationflags=0x08000000)

class HermesApp(tk.Tk):
    def __init__(self):
        super().__init__()
        self.title("Hermes Stack Manager & Control Center")
        self.geometry("900x740")
        self.minsize(800, 650)
        self.configure(bg=BG_COLOR)

        self.statuses = {
            "agent": False,
            "webui": False,
            "9router": False,
            "omniroute": False
        }

        self.setup_ui()
        self.running = True
        self.start_status_thread()

    def setup_ui(self):
        # Header
        header_frame = tk.Frame(self, bg=CARD_BG, highlightbackground=CARD_BORDER, highlightthickness=1)
        header_frame.pack(fill="x", padx=16, pady=12)

        title_box = tk.Frame(header_frame, bg=CARD_BG)
        title_box.pack(side="left", padx=16, pady=12)

        lbl_icon = tk.Label(title_box, text="🚀", font=("Segoe UI", 22), bg=CARD_BG, fg=TEXT_MAIN)
        lbl_icon.pack(side="left", padx=(0, 10))

        text_sub = tk.Frame(title_box, bg=CARD_BG)
        text_sub.pack(side="left")

        lbl_title = tk.Label(text_sub, text="Hermes AI Stack Control Center", font=("Segoe UI", 16, "bold"), bg=CARD_BG, fg=TEXT_MAIN)
        lbl_title.pack(anchor="w")

        lbl_desc = tk.Label(text_sub, text="مدیریت، راه‌اندازی و بررسی زنده سرویس‌های هوش مصنوعی هرمس", font=("Segoe UI", 10), bg=CARD_BG, fg=TEXT_MUTED)
        lbl_desc.pack(anchor="w")

        self.lbl_global_badge = tk.Label(header_frame, text="بررسی وضعیت...", font=("Segoe UI", 10, "bold"), bg="#334155", fg="#FFFFFF", padx=12, pady=4)
        self.lbl_global_badge.pack(side="right", padx=16)

        # Master Actions Toolbar
        actions_bar = tk.Frame(self, bg=BG_COLOR)
        actions_bar.pack(fill="x", padx=16, pady=(0, 12))

        btn_start_all = tk.Button(actions_bar, text="🚀 روشن کردن همه", font=("Segoe UI", 11, "bold"), bg=ACCENT_GREEN, fg=BTN_TEXT, relief="flat", padx=12, pady=6, cursor="hand2", command=self.action_start_all)
        btn_start_all.pack(side="left", expand=True, fill="x", padx=(0, 4))

        btn_stop_all = tk.Button(actions_bar, text="🛑 توقف همه", font=("Segoe UI", 11, "bold"), bg=ACCENT_RED, fg=BTN_TEXT, relief="flat", padx=12, pady=6, cursor="hand2", command=self.action_stop_all)
        btn_stop_all.pack(side="left", expand=True, fill="x", padx=4)

        btn_refresh = tk.Button(actions_bar, text="🔄 به‌روزرسانی", font=("Segoe UI", 11, "bold"), bg=ACCENT_BLUE, fg=BTN_TEXT, relief="flat", padx=12, pady=6, cursor="hand2", command=self.update_status)
        btn_refresh.pack(side="left", expand=True, fill="x", padx=4)

        btn_install = tk.Button(actions_bar, text="🛠️ نصب پیش‌نیازها", font=("Segoe UI", 11, "bold"), bg=ACCENT_PURPLE, fg=BTN_TEXT, relief="flat", padx=12, pady=6, cursor="hand2", command=self.action_run_installer)
        btn_install.pack(side="left", expand=True, fill="x", padx=(4, 0))

        # Cards Container (2x2 Grid)
        grid_frame = tk.Frame(self, bg=BG_COLOR)
        grid_frame.pack(fill="both", expand=True, padx=16, pady=4)
        grid_frame.columnconfigure(0, weight=1)
        grid_frame.columnconfigure(1, weight=1)
        grid_frame.rowconfigure(0, weight=1)
        grid_frame.rowconfigure(1, weight=1)

        # 1. Hermes Agent Card
        self.card_agent = self.create_service_card(
            parent=grid_frame,
            row=0, col=0,
            emoji="🧠",
            title="Hermes Agent (CLI)",
            role="ایجنت خودکار هوش مصنوعی و کدنویسی در خط فرمان",
            target="دستور: hermes",
            open_cmd=self.action_open_terminal,
            open_btn_text="💻 اجرای ترمینال",
            start_cmd=None,
            stop_cmd=None
        )

        # 2. Hermes WebUI Card
        self.card_webui = self.create_service_card(
            parent=grid_frame,
            row=0, col=1,
            emoji="🖥️",
            title="Hermes WebUI",
            role="محیط گرافیکی وب برای چت و مدیریت ایجنت هرمس",
            target="http://127.0.0.1:8787",
            open_cmd=lambda: open_url("http://127.0.0.1:8787"),
            open_btn_text="🌐 ورود به لینک",
            start_cmd=self.action_start_webui,
            stop_cmd=lambda: kill_port(8787)
        )

        # 3. 9Router Card
        self.card_9router = self.create_service_card(
            parent=grid_frame,
            row=1, col=0,
            emoji="🔀",
            title="9Router",
            role="گیت‌وی و پروکسی هوش مصنوعی برای مدیریت کلیدها و مدل‌ها",
            target="http://127.0.0.1:20128",
            open_cmd=lambda: open_url("http://127.0.0.1:20128"),
            open_btn_text="🌐 ورود به لینک",
            start_cmd=self.action_start_9router,
            stop_cmd=lambda: kill_port(20128)
        )

        # 4. OmniRoute Card
        self.card_omniroute = self.create_service_card(
            parent=grid_frame,
            row=1, col=1,
            emoji="🌐",
            title="OmniRoute",
            role="مسیریاب چندمدلی با اتصال OAuth و سوئیچ خودکار",
            target="http://127.0.0.1:20129",
            open_cmd=lambda: open_url("http://127.0.0.1:20129"),
            open_btn_text="🌐 ورود به لینک",
            start_cmd=self.action_start_omniroute,
            stop_cmd=lambda: kill_port(20129)
        )

        # Log Console
        log_frame = tk.Frame(self, bg=CARD_BG, highlightbackground=CARD_BORDER, highlightthickness=1)
        log_frame.pack(fill="x", padx=16, pady=12)

        lbl_log = tk.Label(log_frame, text="📋 لاگ و گزارش لحظه‌ای وضعیت:", font=("Segoe UI", 10, "bold"), bg=CARD_BG, fg=TEXT_MUTED)
        lbl_log.pack(anchor="w", padx=10, pady=(6, 2))

        self.txt_log = tk.Text(log_frame, height=4, bg="#050B14", fg=ACCENT_GREEN, font=("Consolas", 9), relief="flat")
        self.txt_log.pack(fill="both", padx=10, pady=(0, 8))

        self.log_msg("برنامه مدیریت هرمس استک آماده به کار شد.")

    def create_service_card(self, parent, row, col, emoji, title, role, target, open_cmd, open_btn_text="🌐 ورود به لینک", start_cmd=None, stop_cmd=None):
        card = tk.Frame(parent, bg=CARD_BG, highlightbackground=CARD_BORDER, highlightthickness=1)
        card.grid(row=row, column=col, padx=6, pady=6, sticky="nsew")

        # Top line: Title + Status Badge
        top_bar = tk.Frame(card, bg=CARD_BG)
        top_bar.pack(fill="x", padx=12, pady=(12, 6))

        title_lbl = tk.Label(top_bar, text=f"{emoji} {title}", font=("Segoe UI", 13, "bold"), bg=CARD_BG, fg=TEXT_MAIN)
        title_lbl.pack(side="left")

        badge = tk.Label(top_bar, text="بررسی...", font=("Segoe UI", 9, "bold"), bg="#334155", fg="#FFFFFF", padx=8, pady=2)
        badge.pack(side="right")

        # Details
        role_lbl = tk.Label(card, text=role, font=("Segoe UI", 9), bg=CARD_BG, fg="#CBD5E1", wraplength=380, justify="left")
        role_lbl.pack(anchor="w", padx=12, pady=2)

        target_lbl = tk.Label(card, text=target, font=("Segoe UI", 9, "bold"), bg=CARD_BG, fg=ACCENT_BLUE)
        target_lbl.pack(anchor="w", padx=12, pady=(0, 8))

        # Bottom Buttons
        btn_box = tk.Frame(card, bg=CARD_BG)
        btn_box.pack(fill="x", padx=12, pady=(4, 12), side="bottom")

        btn_open = tk.Button(btn_box, text=open_btn_text, font=("Segoe UI", 9, "bold"), bg=ACCENT_BLUE, fg=BTN_TEXT, relief="flat", padx=10, pady=4, cursor="hand2", command=open_cmd)
        btn_open.pack(side="left", expand=True, fill="x", padx=(0, 4))

        if start_cmd:
            btn_start = tk.Button(btn_box, text="▶ استارت", font=("Segoe UI", 9, "bold"), bg=ACCENT_GREEN, fg=BTN_TEXT, relief="flat", padx=8, pady=4, cursor="hand2", command=start_cmd)
            btn_start.pack(side="left", padx=2)

        if stop_cmd:
            btn_stop = tk.Button(btn_box, text="⏹ توقف", font=("Segoe UI", 9, "bold"), bg=ACCENT_RED, fg=BTN_TEXT, relief="flat", padx=8, pady=4, cursor="hand2", command=stop_cmd)
            btn_stop.pack(side="left", padx=(2, 0))

        card.badge = badge
        return card

    def log_msg(self, msg):
        t = time.strftime("%H:%M:%S")
        self.txt_log.insert("end", f"[{t}] {msg}\n")
        self.txt_log.see("end")

    def update_status(self):
        # 1. Agent
        if IS_MAC:
            agent_ok = os.path.exists(os.path.expanduser("~/.local/bin/hermes")) or bool(subprocess.run("which hermes", shell=True, capture_output=True).stdout)
        else:
            agent_ok = bool(subprocess.run("where hermes", shell=True, capture_output=True).stdout)

        # 2. WebUI (8787)
        webui_ok = check_port(8787)

        # 3. 9Router (20128)
        router_ok = check_port(20128)

        # 4. OmniRoute (20129)
        omni_ok = check_port(20129)

        # Update Badges
        self.set_badge(self.card_agent.badge, "آماده ✔" if agent_ok else "یافت نشد ✖", ACCENT_GREEN if agent_ok else ACCENT_RED)
        self.set_badge(self.card_webui.badge, "فعال (RUNNING) ✔" if webui_ok else "متوقف (STOPPED) ✖", ACCENT_GREEN if webui_ok else ACCENT_RED)
        self.set_badge(self.card_9router.badge, "فعال (RUNNING) ✔" if router_ok else "متوقف (STOPPED) ✖", ACCENT_GREEN if router_ok else ACCENT_RED)
        self.set_badge(self.card_omniroute.badge, "فعال (RUNNING) ✔" if omni_ok else "متوقف (STOPPED) ✖", ACCENT_GREEN if omni_ok else ACCENT_RED)

        # Global
        running_cnt = sum([webui_ok, router_ok, omni_ok])
        if running_cnt == 3:
            self.set_badge(self.lbl_global_badge, "هر ۳ سرویس فعال هستند (3/3)", ACCENT_GREEN)
        elif running_cnt > 0:
            self.set_badge(self.lbl_global_badge, f"{running_cnt} سرویس فعال است", "#F59E0B")
        else:
            self.set_badge(self.lbl_global_badge, "سرویس‌ها متوقف هستند (0/3)", ACCENT_RED)

    def set_badge(self, label, text, color):
        label.configure(text=text, bg=color)

    def start_status_thread(self):
        def loop():
            while self.running:
                try:
                    self.update_status()
                except Exception:
                    pass
                time.sleep(3)
        t = threading.Thread(target=loop, daemon=True)
        t.start()

    def action_start_all(self):
        self.log_msg("در حال راه‌اندازی تمام سرویس‌ها...")
        threading.Thread(target=self._bg_start_all, daemon=True).start()

    def _bg_start_all(self):
        if IS_MAC:
            start_script = os.path.expanduser("~/.hermes-stack/start.sh")
            if os.path.exists(start_script):
                subprocess.run(f"bash '{start_script}'", shell=True)
            else:
                self.action_start_9router()
                self.action_start_webui()
                self.action_start_omniroute()
        else:
            ps_script = os.path.expanduser("~/.hermes-stack/start.ps1")
            subprocess.run(["powershell", "-ExecutionPolicy", "Bypass", "-File", ps_script], creationflags=0x08000000)
        time.sleep(2)
        self.update_status()
        self.log_msg("دستور اجرای تمام سرویس‌ها ارسال شد.")

    def action_stop_all(self):
        self.log_msg("در حال توقف تمام سرویس‌ها...")
        for p in [8787, 20128, 20129]:
            kill_port(p)
        time.sleep(1)
        self.update_status()
        self.log_msg("سرویس‌ها متوقف شدند.")

    def action_open_terminal(self):
        self.log_msg("اجرای ترمینال Hermes Agent...")
        if IS_MAC:
            subprocess.run(["osascript", "-e", 'tell app "Terminal" to do script "hermes"'])
        else:
            subprocess.run(["cmd.exe", "/c", "start powershell.exe -NoExit -Command hermes"])

    def action_start_webui(self):
        self.log_msg("استارت Hermes WebUI...")
        if IS_MAC:
            webui_dir = os.path.expanduser("~/hermes-webui")
            cmd = f"cd '{webui_dir}' && export HERMES_WEBUI_PORT=8787 && nohup .venv/bin/python server.py > ~/.hermes/webui.log 2>&1 &"
            subprocess.run(cmd, shell=True)
        else:
            launcher = os.path.expanduser("~/hermes-webui/start.ps1")
            subprocess.run(["powershell", "-ExecutionPolicy", "Bypass", "-File", launcher, "-Port", "8787"], creationflags=0x08000000)

    def action_start_9router(self):
        self.log_msg("استارت 9Router...")
        if IS_MAC:
            cmd = "nohup 9router -p 20128 -H 127.0.0.1 -n > ~/.hermes/9router.log 2>&1 &"
            subprocess.run(cmd, shell=True)
        else:
            subprocess.run(["cmd.exe", "/c", "9router -p 20128 -H 127.0.0.1 -n -t"], creationflags=0x08000000)

    def action_start_omniroute(self):
        self.log_msg("استارت OmniRoute...")
        if IS_MAC:
            cmd = "nohup omniroute serve --port 20129 --no-open > ~/.hermes/omni.log 2>&1 &"
            subprocess.run(cmd, shell=True)
        else:
            subprocess.run(["powershell", "-Command", "omniroute serve --port 20129 --no-open --daemon"], creationflags=0x08000000)

    def action_run_installer(self):
        if IS_MAC:
            script = os.path.expanduser("~/.hermes-stack/install-mac.sh")
            if not os.path.exists(script):
                script = os.path.join(os.path.dirname(__file__), "install-mac.sh")
            if os.path.exists(script):
                subprocess.run(["osascript", "-e", f'tell app "Terminal" to do script "bash \'{script}\'"'])
        else:
            script = os.path.expanduser("~/.hermes-stack/HermesManager/Install-HermesStack.ps1")
            subprocess.run(["powershell", "-NoExit", "-ExecutionPolicy", "Bypass", "-File", script])

if __name__ == "__main__":
    app = HermesApp()
    app.mainloop()
