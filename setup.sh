#!/data/data/com.termux/files/usr/bin/bash
# 💀 Matrix GitHub Auto Push Setup for Termux
# Commands: git safe  → mark folder safe
#            push      → create/use repo + push files

SAFE_SCRIPT_PATH="$PREFIX/bin/git-safe"
PUSH_SCRIPT_PATH="$PREFIX/bin/push"

GREEN="\033[1;32m"; RED="\033[1;31m"; BLUE="\033[1;34m"; YELLOW="\033[1;33m"; RESET="\033[0m"

echo -e "${BLUE}⚙️ Setting up Matrix GitHub automation...${RESET}"

# ========== git safe ==========
cat > $SAFE_SCRIPT_PATH <<'EOF'
#!/data/data/com.termux/files/usr/bin/bash
GITHUB_DIR="$HOME/storage/shared/#GitHub"
green="\033[1;32m"; red="\033[1;31m"; blue="\033[1;34m"; yellow="\033[1;33m"; reset="\033[0m"

echo -e "\n${blue}==============================${reset}"
echo -e "${blue}🧱 Git Safe Directory Manager${reset}"
echo -e "${blue}==============================${reset}\n"

if [ ! -d "$GITHUB_DIR" ]; then
  echo -e "${red}❌ Folder not found: $GITHUB_DIR${reset}"
  exit 1
fi

cd "$GITHUB_DIR" || exit
i=1
for folder in */; do
  echo "[$i] ${folder%/}"
  folders[$i]="$folder"
  ((i++))
done

read -p "👉 Select folder number to mark safe: " choice
SAFE_FOLDER="${folders[$choice]}"

if [ -z "$SAFE_FOLDER" ]; then
  echo -e "${red}❌ Invalid selection${reset}"
  exit 1
fi

FULL_PATH="$GITHUB_DIR/$SAFE_FOLDER"
git config --global --add safe.directory "$FULL_PATH"

echo -e "${green}✅ Marked as safe: $FULL_PATH${reset}"
echo -e "${yellow}⏳ Waiting 10s before continuing...${reset}"
sleep 10
echo -e "${green}✨ Done! You can now run 'push' to upload.${reset}"
EOF

# ========== push ==========
cat > $PUSH_SCRIPT_PATH <<'EOF'
#!/data/data/com.termux/files/usr/bin/bash
GITHUB_DIR="$HOME/storage/shared/#GitHub"
TOKEN_FILE="$HOME/.github_token"
USERNAME_FILE="$HOME/.github_username"
EMAIL_FILE="$HOME/.github_email"
GREEN="\033[1;32m"; RED="\033[1;31m"; BLUE="\033[1;34m"; YELLOW="\033[1;33m"; RESET="\033[0m"

matrix_text() {
  for ((i=0; i<${#1}; i++)); do
    printf "${GREEN}%s${RESET}" "${1:$i:1}"
    sleep 0.03
  done
  echo
}

matrix_text "🚀 Initializing Matrix Push Engine..."
sleep 1

if [ ! -f "$TOKEN_FILE" ]; then
  echo -e "${YELLOW}🔑 Enter GitHub credentials:${RESET}"
  read -p "👤 Username: " USERNAME
  read -p "📧 Email: " EMAIL
  read -p "🪙 Personal Access Token: " TOKEN
  echo "$USERNAME" > "$USERNAME_FILE"
  echo "$EMAIL" > "$EMAIL_FILE"
  echo "$TOKEN" > "$TOKEN_FILE"
else
  USERNAME=$(cat "$USERNAME_FILE")
  EMAIL=$(cat "$EMAIL_FILE")
  TOKEN=$(cat "$TOKEN_FILE")
fi
git config --global user.name "$USERNAME"
git config --global user.email "$EMAIL"

matrix_text "💡 Repository setup..."
echo "[1] Create new repository"
echo "[2] Use existing repository link"
read -p "👉 Choose option: " opt

if [ "$opt" = "1" ]; then
  read -p "🧱 Repository name: " REPO_NAME
  REPO_LINK="https://github.com/$USERNAME/$REPO_NAME.git"
  CREATE_STATUS=$(curl -s -o /dev/null -w "%{http_code}" \
    -H "Authorization: token $TOKEN" \
    -H "Accept: application/vnd.github+json" \
    -d "{\"name\":\"$REPO_NAME\"}" \
    https://api.github.com/user/repos)
  if [ "$CREATE_STATUS" = "201" ]; then
    echo -e "${GREEN}✅ Repository created.${RESET}"
  elif [ "$CREATE_STATUS" = "422" ]; then
    echo -e "${BLUE}ℹ️ Repository already exists.${RESET}"
  else
    echo -e "${RED}❌ Failed (status $CREATE_STATUS)${RESET}"
    exit 1
  fi
elif [ "$opt" = "2" ]; then
  read -p "🔗 Repository link: " REPO_LINK
else
  echo -e "${RED}❌ Invalid option${RESET}"
  exit 1
fi

cd "$GITHUB_DIR" || exit
echo -e "\n${YELLOW}📂 Choose folder to push:${RESET}"
i=1
for folder in */; do
  echo "[$i] ${folder%/}"
  folders[$i]="$folder"
  ((i++))
done
read -p "👉 Folder number: " choice
TARGET="${folders[$choice]}"
cd "$GITHUB_DIR/$TARGET" || exit

matrix_text "🚀 Preparing to push '$TARGET'..."

SAFE_CHECK=$(git config --global --get-all safe.directory | grep "$PWD")
if [ -z "$SAFE_CHECK" ]; then
  echo -e "${YELLOW}⚠️ Adding safe.directory for this folder...${RESET}"
  git config --global --add safe.directory "$PWD"
  sleep 3
fi

if [ ! -d ".git" ]; then
  git init
  git branch -M main
  echo -e "${BLUE}📦 Initialized new Git repository.${RESET}"
fi

git remote remove origin 2>/dev/null
git remote add origin "https://$TOKEN@${REPO_LINK#https://}"
git add .
git commit -m "Auto-update: $(date)" 2>/dev/null

matrix_text "📤 Uploading to GitHub..."
if git push -u origin main 2>/dev/null; then
  echo -e "${GREEN}✅ Pushed successfully!${RESET}"
else
  echo -e "${YELLOW}⚠️ Syncing with remote before retry...${RESET}"
  git fetch origin main 2>/dev/null
  git merge origin/main --allow-unrelated-histories --no-edit 2>/dev/null
  if git push -u origin main; then
    echo -e "${GREEN}✅ Pushed successfully after sync!${RESET}"
  else
    echo -e "${RED}❌ Push failed. Check repo/token (Run push once again).${RESET}"
  fi
fi

matrix_text "🎉 All done. The Matrix prevails."
EOF

chmod +x $SAFE_SCRIPT_PATH
chmod +x $PUSH_SCRIPT_PATH

echo -e "\n${GREEN}✅ Setup complete!${RESET}"
echo "Now you can use:"
echo -e "${BLUE}git safe${RESET} → to mark folders safe"
echo -e "${GREEN}push${RESET}     → to upload or update repositories"
