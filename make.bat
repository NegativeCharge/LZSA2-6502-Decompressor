cd .\tests\
for %%x in (*.lzsa2) do del "%%x" 
for %%x in (*.bin) do ..\tools\lzsa.exe -f2 -r "%%x" "%%~nx.bin.lzsa2"

cd ..
cmd /c "BeebAsm.exe -v -i LZSA2_test.s.asm -do LZSA2_test.ssd -opt 3"