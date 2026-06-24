@echo off
REM ─────────────────────────────────────────────────────────────────
REM  deploy-render.bat – Push code lên GitHub để Render tự deploy
REM  Sử dụng: chạy file này trong thư mục lavalink
REM ─────────────────────────────────────────────────────────────────

echo [1/4] Kiem tra git status...
git status

echo.
echo [2/4] Stage tat ca file thay doi...
git add .

echo.
set /p MSG="[3/4] Nhap commit message (Enter de dung default): "
if "%MSG%"=="" set MSG=deploy: update lavalink config

git commit -m "%MSG%"

echo.
echo [4/4] Push len GitHub (Render se tu dong deploy)...
git push origin main

echo.
echo ✅ Done! Vao https://dashboard.render.com de theo doi qua trinh deploy.
pause
