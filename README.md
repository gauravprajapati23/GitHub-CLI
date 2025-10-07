# 💀 The Matrix GitHub CLI
> **Automate GitHub uploads directly from Termux with animations, safe directories, and a full setup flow.**  
> No manual commands — just run `git safe` and `push` 😎

---

## ⚙️ Features
✅ One-time setup  
✅ Auto repository creation or reuse  
✅ Safe directory configuration  
✅ Fancy Matrix-style animations 🟢  
✅ Retry logic if push fails  
✅ Works fully offline (after setup)

---

## 🧩 Requirements
- Android with **Termux**
- **GitHub account**
- **Personal Access Token (PAT)** (with repo access)
- Internet connection (for first setup)

---

## 🧰 Installation (Step-by-Step)

### 1️⃣ Update and install basic packages
```bash
pkg update && pkg upgrade -y
pkg install git curl -y
```

### 2️⃣ Enable Termux storage access
```bash
termux-setup-storage
```
> Allow permission when prompted.  
> This will create a shared folder like:
> ```
> /storage/emulated/0
> ```

---

### 3️⃣ Create the GitHub main folder
```bash
mkdir -p /storage/emulated/0/#GitHub
```

---

### 4️⃣ Download and run Matrix setup script
```bash
cd 
git clone https://github.com/gauravprajapati23/GitHub-CLI.git
cd GitHub CLI
bash setup.sh
```

> 🔹 Replace `<YOUR_USERNAME>` and `<YOUR_REPO>` with your GitHub repo name where you stored this script.  
> The setup will install two new commands:
> - `git safe` → Add safe directory  
> - `push` → Upload project to GitHub

---

## 🧱 Usage Guide

### 🛡️ 1. Mark your folder as safe
Move or create your project inside:
```
/storage/emulated/0/#GitHub/
```

Then run:
```bash
git safe
```
➡️ Choose your project folder number  
✅ It will be marked safe automatically.

---

### 🚀 2. Upload your project to GitHub
```bash
push
```

You’ll see:
- Matrix-style animations 🌱  
- Option to **create** or **use existing** repository  
- Folder list from `#GitHub`  
- Auto commit + push

If first push fails due to sync issue, it retries automatically.

> ❗ If still fails, just run:
> ```
> push
> ```
> again — it’ll succeed in the second attempt 😎

---

## 🔑 Personal Access Token Setup (First Time Only)
1. Go to your GitHub profile → **Settings → Developer settings → Personal access tokens**
2. Generate new token → enable these scopes:
   - `repo`
   - `workflow`
3. Copy the token and paste when script asks.

The token is securely saved in:
```
~/.github_token
```

---

## 📦 Folder Structure
```
#GitHub/
 ├── MyWebsite/
 │   ├── index.html
 │   ├── style.css
 │   └── ...
 └── AmbulanceApp/
     ├── index.html
     ├── script.js
     └── ...
```

---

## 🧠 Example Workflow

```bash
termux-setup-storage
mkdir -p /storage/emulated/0/#GitHub/MyWebsite
cd /storage/emulated/0/#GitHub/MyWebsite
echo "<h1>Hello Matrix</h1>" > index.html

git safe
push
```

🎉 Boom! Your website auto-uploads to GitHub.  
Next time — just edit files and type:
```bash
push
```
to instantly sync.

---

## 🧩 Common Fixes

| Problem | Solution |
|----------|-----------|
| `fatal: detected dubious ownership` | Run `git safe` for that folder |
| `failed to push some refs` | Run `push` again |
| `origin not found` | Re-enter repo link when prompted |
| `token expired` | Delete `~/.github_token` and rerun setup |

---

## 💚 Credits
Made with ❤️ by **The Matrix Crew**  
Termux Automation by **Gaurav Prajapati** ⚡  
> “💻 Code flows like rain in the Matrix.”

---

### 🧾 License
MIT License © 2025
