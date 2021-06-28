# N Bits M Size LIFO Stack

SystemVerilog source code [NxMStack.v](https://github.com/ChrisShakkour/Logic-Design-Building-Blocks/blob/main/N-Bit%20M-Width%20Stack/RTL_src/NxMStack.sv)

## Simulation Waveform
SystemVerilog Simulation source code [NxMStack_tb.sv](https://github.com/ChrisShakkour/Logic-Design-Building-Blocks/blob/main/N-Bit%20M-Width%20Stack/Sim_src/NxMStack_tb.sv)

N=3 M=8 -> 8 cells each with 3 bits, Push till Stack overflow, Pop till Stack is empty:

![alt text](https://github.com/ChrisShakkour/Logic-Design-Building-Blocks/blob/main/N-Bit%20M-Width%20Stack/Figures/3x8Stack_waveform.JPG)

N=3 M=5 -> 5 cells, each with 3 bits, push more than 5 times and pop till empty,
this test is intended to show the functionality when stack has reached overflow but still gets push requests... 

![alt text](https://github.com/ChrisShakkour/Logic-Design-Building-Blocks/blob/main/N-Bit%20M-Width%20Stack/Figures/3x5Stack_waveform.JPG)
