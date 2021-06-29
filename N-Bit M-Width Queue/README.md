# N Bits M Size FIFO Queue

SystemVerilog source code [NxMQueue.v](https://github.com/ChrisShakkour/Logic-Design-Building-Blocks/blob/main/N-Bit%20M-Width%20Queue/RTL_src/NxMQueue.sv)

## Simulation Waveform
SystemVerilog Simulation source code [NxMQueue_tb.sv](https://github.com/ChrisShakkour/Logic-Design-Building-Blocks/blob/main/N-Bit%20M-Width%20Queue/Sim_src/NxMQueue_tb.sv)

N=3 M=8 -> 8 cells each with 3 bits, enqueue till queue overflow, dequeue till Queue is empty:

![alt text](https://github.com/ChrisShakkour/Logic-Design-Building-Blocks/blob/main/N-Bit%20M-Width%20Queue/Figures/3x8Queue_waveform.JPG)

N=3 M=5 -> 5 cells, each with 3 bits, enqueue more than 5 times and dequeue till empty,
this test is intended to show the functionality when queue has reached overflow but still gets enqueue requests... 

![alt text](https://github.com/ChrisShakkour/Logic-Design-Building-Blocks/blob/main/N-Bit%20M-Width%20Queue/Figures/3x5Queue_waveform.JPG)
