@echo off
CHCP 65001

if not exist env (
  set /p num="输入对应编号选择要安装的 Python 版本：【1】3.8 【2】3.9 【3】3.10 :"
) else (
  GOTO skip2
)

if %num% == 1 (
  set env_name=py38
  set python_version=3.8
  ) else if  %num% == 2  (
  set env_name=py39
  set python_version=3.9
  ) else if  %num% == 3 (
  set env_name=py310
  set python_version=3.10
  ) else (
  echo 无效的选择
  pause
  exit /b 1
)
echo 正在创建 %env_name% 的 Python 环境...
call conda create -p .\env python=%python_version% -y

set /p torch_version="输入对应编号选择要安装Pytorch对应的cuda版本：【1】cu116 【2】cu117 【3】cu118 【4】cpu: "

if "%torch_version%"=="1" (
  env\python.exe -m pip uninstall torch torchvision torchaudio
  env\python.exe -m pip --no-cache-dir install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu116 --no-warn-script-location
) else if "%torch_version%"=="2" (
  env\python.exe -m pip uninstall torch torchvision torchaudio
  env\python.exe -m pip --no-cache-dir install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu117 --no-warn-script-location
) else if "%torch_version%"=="3" (
  env\python.exe -m pip uninstall torch torchvision torchaudio
  env\python.exe -m pip --no-cache-dir install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118 --no-warn-script-location
) else if "%torch_version%"=="4" (
  env\python.exe -m pip uninstall torch torchvision torchaudio
  env\python.exe -m pip --no-cache-dir install torch torchvision torchaudio --no-warn-script-location
) else (
  echo 无效的选择
  pause
  exit /b 1
)

:skip2
echo Python 正在拉取github仓库。。。

set github_address=https://gitee.com/shi-yachen/yolov8-all-in-one.git
git clone %github_address% temp
if %errorlevel% neq 0 (
    echo github仓库拉取失败，程序即将退出。。。
        pause
    exit /b 1
) else (
    ROBOCOPY temp . /MOV /E
    rmdir /S /Q temp
    echo github仓库拉取完成！正在安装依赖。。。
)

echo 正在安装requirements.txt...
env\python.exe -m pip install -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple --no-warn-script-location
echo requirements安装完成！正在进行最后的调整。。。

ROBOCOPY fix . /MOV /E
rmdir /S /Q fix
rmdir /S /Q .git
echo 大功告成！开始体验yolov8吧！
pause