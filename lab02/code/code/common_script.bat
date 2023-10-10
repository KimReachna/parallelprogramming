set julia_path=C:\Users\posen\AppData\Local\Programs\Julia-1.9.3\bin\julia.exe
set task1_script_path=C:\Users\posen\Reachna\Parallel-Computing\Lab2\code\task1.jl
set task2_script_path=C:\Users\posen\Reachna\Parallel-Computing\Lab2\code\task2.jl
set /a threads=12  # max number of threads to be used
set task1_output_file=C:\Users\posen\Reachna\Parallel-Computing\Lab2\code\result_task1.csv
set task2_output_file=C:\Users\posen\Reachna\Parallel-Computing\Lab2\code\result_task2.csv
set /a input_size=6 # max input size to be tested
for /l %%x in (1,1,%input_size%) do (
    for /l %%i in (1,1,%threads%) do (
        %julia_path% --threads=%%i %task1_script_path% %%x >> %task1_output_file%
        %julia_path% --threads=%%i %task2_script_path% %%x >> %task2_output_file%
    )
)
