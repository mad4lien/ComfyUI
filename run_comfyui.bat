@echo off
cd /d %~dp0
call venv\Scripts\activate.bat
python main.py --enable-manager --listen 0.0.0.0 --port 8000 %*
pause
