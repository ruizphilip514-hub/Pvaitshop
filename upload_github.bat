@echo off
setlocal
title Upload pvaitshop.com to GitHub

echo ==========================================
echo       PVAITSHOP.COM - GITHUB UPLOADER
echo ==========================================
echo.

REM Go to your website folder
cd /d "C:\Users\SBC\Downloads\pvaitshop.com\pvaitshop.com\pvaitshop.com"
if errorlevel 1 (
    echo ERROR: Website folder was not found.
    echo Check that this folder still exists:
    echo C:\Users\SBC\Downloads\pvaitshop.com\pvaitshop.com\pvaitshop.com
    goto :failed
)

REM Check Git installation
git --version >nul 2>&1
if errorlevel 1 (
    echo ERROR: Git is not installed or is not in PATH.
    goto :failed
)

REM Make sure this folder points to the intended GitHub repository
git remote get-url origin >nul 2>&1
if errorlevel 1 (
    git remote add origin https://github.com/ruizphilip514-hub/Pvaitshop.git
) else (
    git remote set-url origin https://github.com/ruizphilip514-hub/Pvaitshop.git
)
if errorlevel 1 (
    echo ERROR: Could not configure the GitHub remote.
    goto :failed
)

REM Use main branch
git branch -M main
if errorlevel 1 goto :failed

echo.
echo Checking and staging changes...
git add .
if errorlevel 1 (
    echo ERROR: Could not add files.
    goto :failed
)

REM Create a commit only when there are staged changes
git diff --cached --quiet
if errorlevel 1 (
    echo.
    echo Creating commit...
    git commit -m "Website update"
    if errorlevel 1 (
        echo ERROR: Commit failed. Check your Git name and email settings.
        goto :failed
    )
) else (
    echo No new changes to commit.
)

echo.
echo Uploading to GitHub...
git push -u origin main
if errorlevel 1 (
    echo.
    echo ERROR: Upload failed.
    echo Check your GitHub browser login and write permission
    echo for https://github.com/ruizphilip514-hub/Pvaitshop
    goto :failed
)

echo.
echo ==========================================
echo SUCCESS: Your files were pushed to GitHub.
echo https://github.com/ruizphilip514-hub/Pvaitshop
echo ==========================================
echo.
pause
exit /b 0

:failed
echo.
echo ==========================================
echo UPLOAD DID NOT COMPLETE. Read the error above.
echo ==========================================
echo.
pause
exit /b 1
