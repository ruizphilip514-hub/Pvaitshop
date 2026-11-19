@echo off
setlocal EnableExtensions
title PVAITSHOP - One Click GitHub Sync

set "PROJECT_DIR=C:\Users\SBC\Downloads\pvaitshop.com\pvaitshop.com\pvaitshop.com"
set "REPO_URL=https://github.com/ruizphilip514-hub/Pvaitshop.git"
set "BRANCH=main"

echo.
echo ==========================================================
echo             PVAITSHOP - ONE CLICK GITHUB SYNC
echo ==========================================================
echo.

REM 1. Check project folder
if not exist "%PROJECT_DIR%\" (
    echo ERROR: Project folder not found:
    echo "%PROJECT_DIR%"
    goto :fail
)
cd /d "%PROJECT_DIR%" || goto :fail

REM 2. Check Git
git --version
if errorlevel 1 (
    echo ERROR: Git is not installed or not available in PATH.
    goto :fail
)

REM 3. Check Git repository
if not exist ".git\" (
    echo Initializing Git repository...
    git init || goto :fail
)

REM 4. Check commit identity
for /f "delims=" %%A in ('git config user.name') do set "GIT_USER=%%A"
for /f "delims=" %%A in ('git config user.email') do set "GIT_EMAIL=%%A"

if not defined GIT_USER (
    echo ERROR: Git author name is not configured.
    echo Run: git config --global user.name "Your Name"
    goto :fail
)
if not defined GIT_EMAIL (
    echo ERROR: Git author email is not configured.
    echo Run: git config --global user.email "your-email@example.com"
    goto :fail
)

REM 5. Point origin to the intended repository
git remote get-url origin >nul 2>&1
if errorlevel 1 (
    git remote add origin "%REPO_URL%" || goto :fail
) else (
    git remote set-url origin "%REPO_URL%" || goto :fail
)

REM 6. Use main branch
git branch -M "%BRANCH%" || goto :fail

REM 7. Stage local files and commit local changes first
echo.
echo [1/4] Checking local changes...
git add -A || goto :fail

git diff --cached --quiet
if errorlevel 1 (
    echo Creating local commit...
    git commit -m "Website update" || goto :fail
) else (
    echo No local changes to commit.
)

REM 8. Fetch latest GitHub state
echo.
echo [2/4] Fetching GitHub updates...
git fetch origin || goto :fail

REM 9. Merge remote main if it exists; do not overwrite either side
echo.
echo [3/4] Synchronizing local and GitHub history...
git show-ref --verify --quiet "refs/remotes/origin/%BRANCH%"
if not errorlevel 1 (
    git merge --no-edit --allow-unrelated-histories "origin/%BRANCH%"
    if errorlevel 1 (
        echo.
        echo MERGE CONFLICT OR MERGE ERROR DETECTED.
        echo The script has stopped to protect your files.
        echo Resolve the conflict, then run this BAT file again.
        goto :fail
    )
) else (
    echo No remote main branch found. This may be a new empty repository.
)

REM 10. Push
echo.
echo [4/4] Pushing to GitHub...
git push -u origin "%BRANCH%"
if errorlevel 1 (
    echo.
    echo PUSH FAILED. Check authentication and repository write access.
    goto :fail
)

echo.
echo ==========================================================
echo SUCCESS: Local project is synchronized with GitHub.
echo Repository: https://github.com/ruizphilip514-hub/Pvaitshop
echo ==========================================================
echo.
pause
exit /b 0

:fail
echo.
echo ==========================================================
echo PROCESS STOPPED. Read the error message above.
echo Your local committed work has not been force-overwritten.
echo ==========================================================
echo.
pause
exit /b 1
