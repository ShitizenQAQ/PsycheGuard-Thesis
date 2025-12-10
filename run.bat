@echo off
cd /d %~dp0

echo =======================================================
echo      PsycheGuard Launcher (Safe Mode)
echo =======================================================

if not exist "backend" (
    echo [ERROR] Folder 'backend' not found!
    pause
    exit
)

echo [1/2] Starting Backend (Spring Boot)...
start "Backend Server" cmd /k "cd backend && .\mvnw.cmd spring-boot:run"

echo Waiting for backend to initialize...
timeout /t 5 >nul

echo [2/2] Starting Frontend (Vue 3)...
start "Frontend Client" cmd /k "cd frontend && npm run dev"

echo =======================================================
echo      Done! Please check the new windows.
echo =======================================================
pause