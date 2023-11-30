# 6502-Cleaning-game
This is a game i tried to make in assembly for 6502.

To run it you must download [Dummy6502](https://github.com/rdeioris/dummy6502) and set it to a value between 1000 and 10000 Hz.

Your scope is to "clean" the screen from the mud. Your points is stored in the zero page at the address 0x02

To build this game you need to install [necroassembler](https://github.com/rdeioris/necroassembler) for python and run "necro_6502.exe .\6502game.asm .\output\game.bin"
