# Oscilloscope Chess
A chess game is coded such that it is played with a keypad as the controller and an oscilloscope as the screen display.
The only rules implemented were castling, the general movement of each piece and capturing of pieces. En passant, promotion, check and checkmate were not implemented.
The game requires a keypad, 2 DAC circuits, an oscilloscope and an ATmega128 processor.
The game is completely coded in assembly language.

The game is displayed on the oscilloscope with chess pieces as triangles for player 1 and circles for player 2.
Each piece contains a letter allowing the role of each piece to be identified.
The oscilloscope must be set at 0.2V per grid with a 8x8 grid display. This will allow the cursor and shapes to fill one grid each. 

# The files:
## main.asm
The assembly code containing all the functions required to create the chess game.

## Python (folder)
A python script was used to draw each shape with the right digital values. The values are then stored in assembly to allow the shapes to be drawn on the oscilloscope.


