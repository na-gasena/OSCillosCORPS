@echo off

@REM Run a Processing sketch
@REM Change the path of "\processing-java.exe" according to your environment
start "" "C:\Freefile\Coding\Processing\processing-4.3\processing-java.exe"  --sketch="%~dp0..\pde\HandsDemo" --run

@REM Run a Python script
@REM WebCam4 (Iriun Webcam))
@REM start "" python "%~dp0..\py\hands.py" --input 4
@REM WebCam2 (HD Webcam C270)
start "" python "%~dp0..\py\hands.py" --input 2
