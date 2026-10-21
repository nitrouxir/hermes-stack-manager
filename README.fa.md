# کنترل پنل و نصب‌کننده خودکار هرمس استک (Hermes Stack Manager)

<div dir="rtl">

[![ورژن](https://img.shields.io/badge/%D9%88%D8%B1%DA%98%D9%86-v2.0.0-blue.svg)](https://github.com/faradoros/hermes-stack-manager/releases)
[![اکوسیستم](https://img.shields.io/badge/%D8%A7%DA%A9%D9%88%D8%B3%DB%8C%D8%B3%D8%AA%D9%85-%D9%86%DB%8C%D8%AA%D8%B1%D9%88%DA%A9%D8%B3%20(Nitroux)-indigo.svg)](https://nitroux.ir)
[![سیستم‌عامل](https://img.shields.io/badge/%D8%B3%DB%8C%D8%B3%D8%AA%D9%85%E2%80%8C%D8%B9%D8%A7%D9%85%D9%84-Windows%20%7C%20macOS-brightgreen.svg)](#)
[![مجوز](https://img.shields.io/badge/%D9%85%D8%AC%D9%88%D8%B2-MIT-orange.svg)](LICENSE)

> **هرمس استک منیجر (Hermes Stack Manager)** یک کنترل پنل گرافیکی دسکتاپ (GUI) و اسکریپت نصب خودکار برای راه‌اندازی و مدیریت صفر تا صد ابزارهای هوش مصنوعی **هرمس (Hermes Agent ،Hermes WebUI و 9Router)** روی سیستم‌های شخصی است.
>
> 🌐 توسعه‌یافته در اکوسیستم هوش مصنوعی **[نیتروکس (Nitroux.ir)](https://nitroux.ir)**.

---

[🇬🇧 Switch to English Guide](README.md)

---

## 📌 هرمس استک چیست و چه کار می‌کند؟

این استک تمام ابزارهای لازم برای اجرای محلی یک ایجنت هوش مصنوعی قدرتمند با رابط کاربری وب را روی سیستم شما آماده می‌کند:

1. **Hermes Agent**: ایجنت خودمختار و هوشمند هوش مصنوعی برای انجام کارهای برنامه‌نویسی و ترمینال.
2. **Hermes WebUI**: رابط کاربری تحت وب مدرن برای چت و تعامل با ایجنت در مرورگر (پورت `8787`).
3. **9Router**: روتر و پروکسی هوشمند محلی برای اتصال مدل‌ها و تبدیل APIها با استانداردهای سازگار با OpenAI (پورت `20128`).
4. **Hermes Manager**: کنترل پنل گرافیکی دسکتاپ جهت استارت، استاپ، مانیتور وضعیت و آپدیت خودکار تمام سرویس‌ها با یک کلیک.

---

## 🚀 راهنمای سریع راه‌اندازی (نصب در ۳ مرحله)

### مرحله ۱: دانلود پروژه

می‌توانید آخرین نسخه پروژه را از گیت‌هاب دریافت کنید:

**روش الف (با دستور Git):**
یک ترمینال (PowerShell) باز کنید و دستور زیر را بزنید:
```powershell
git clone https://github.com/faradoros/hermes-stack-manager.git
cd hermes-stack-manager
```

**روش ب (دانلود مستقیم فایل فشرده):**
فایل Zip آخرین نسخه را از صفحه [Releases گیت‌هاب](https://github.com/faradoros/hermes-stack-manager/releases/latest) دانلود کرده و از حالت فشرده خارج (Extract) کنید.

---

### مرحله ۲: نصب خودکار و آماده‌سازی سیستم (فقط یک‌بار)

داخل پوشه پروژه، روی فایل `Install-HermesStack.ps1` راست‌کلیک کرده و گزینه **Run with PowerShell** را بزنید، یا در پنجره PowerShell دستور زیر را اجرا کنید:

```powershell
powershell -ExecutionPolicy Bypass -File .\Install-HermesStack.ps1
```

#### این اسکریپت چه کارهایی را خودکار انجام می‌دهد؟
* بررسی پیش‌نیازها (Git، Node.js، پایتون) و نصب خودکار مواردی که روی سیستمتان نیست.
* نصب و راه‌اندازی پکیج `9Router`.
* دانلود و کانفیگ محیط مجازی `Hermes Agent` و `Hermes WebUI`.
* سینک خودکار پکیج‌های پایتون با سرعت بالا با ابزار `uv`.
* تنظیم خودکار کلیدهای API و فایل کانفیگ `config.yaml`.
* ساخت آیکون میانبر (Shortcut) روی دسکتاپ ویندوز برای دسترسی آسان همیشگی.

---

### مرحله ۳: اجرا و کار با کنترل پنل (GUI)

پس از اتمام نصب، برای اجرای کنترل پنل:
* **در ویندوز:** روی شورتکات دسکتاپ **Hermes Stack Manager** یا فایل `Run-Manager.bat` دابل‌کلیک کنید.
* **در مک یا لینوکس (نسخه پایتون):**
  ```bash
  python HermesManager.py
  ```

با باز شدن پنل:
1. روی دکمه **Start Stack** کلیک کنید تا سرویس‌ها بالا بیایند.
2. روی دکمه **Open WebUI** کلیک کنید تا رابط وب هرمس در مرورگر شما باز شود:
   👉 **`http://localhost:8787`**

---

## 🛠️ دستورات خط فرمان (در صورت عدم استفاده از GUI)

اگر مایلید بدون محیط گرافیکی سرویس‌ها را مدیریت کنید:

| کارایی | دستور در پاورشل (PowerShell) |
|---|---|
| **روشن کردن سرویس‌ها** | `powershell -ExecutionPolicy Bypass -File .\start.ps1` |
| **خاموش کردن سرویس‌ها** | `powershell -ExecutionPolicy Bypass -File .\stop.ps1` |
| **بررسی وضعیت سرویس‌ها** | `powershell -ExecutionPolicy Bypass -File .\status.ps1` |
| **آپدیت تمام بخش‌ها** | `powershell -ExecutionPolicy Bypass -File .\update.ps1` |

---

## 🌐 پشتیبانی و منابع نیتروکس (Nitroux)

این پروژه بخشی از زنجیره ابزارهای هوش مصنوعی **نیتروکس** است. برای دسترسی به مقالات آموزشی، مدل‌های پشتیبانی‌شده، پرامپت‌ها و اطلاعات بیشتر به وب‌سایت مراجعه فرمایید:

🔗 **[https://nitroux.ir](https://nitroux.ir)**

---

## 📄 لایسنس
این پروژه تحت مجوز متن‌باز [MIT License](LICENSE) منتشر شده است.
</div>
