set julia_path=D:\Soft\Julia-1.6.7\bin\julia.exe
set script_path=D:\work\study\2023-2024\Параллельное программирование\lab02\task1.jl
set /a threads=12
set output_file=D:\work\study\2023-2024\Параллельное программирование\lab02\result.txt

for /l %%i in (1,1,%threads%) do (
    %julia_path% --threads=%%i %script_path% >> %output_file%
)
