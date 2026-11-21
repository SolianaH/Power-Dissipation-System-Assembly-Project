# Power Reserve Display

A RISC-V assembly project that simulates a power reserve display. The program shows a power-level bar, four appliance icons, and a flashing warning when the reserve is low. Keyboard input changes the power level and updates the display.

## Features

- Six power levels, from 0 to 5.
- A triangular bar that changes its fill and color with the power level.
- Fridge, TV, lights, and AC icons that change color as the level increases.
- A flashing warning at levels 0 and 1.

## Requirements

- A RISC-V simulator with the MustyV display and keyboard memory-mapped I/O used by the program.
- A display configured to **192 × 144 pixels**.
- The project's assembly source file (`.s`).

The program uses simulator-specific memory addresses for the framebuffer, palette, display update, and keyboard. It may not work in a simulator with a different memory map.

## Build and run

1. Open or load the `.s` source file in the compatible simulator.
2. Configure the display to 192 × 144 pixels.
3. Assemble the program and run it.
4. Use the keyboard controls below to change the power level.

## Controls

| Key | Action |
| --- | --- |
| `k` | Increase the power level, up to 5. |
| `j` | Decrease the power level, down to 0. |

## Power levels

| Level | Fridge | TV | Lights | AC | Warning |
| --- | --- | --- | --- | --- | --- |
| 0 | Black | Black | Black | Black | Flashing |
| 1 | Red | Red | Red | Red | Flashing |
| 2 | Green | Red | Red | Red | Off |
| 3 | Green | Green | Red | Red | Off |
| 4 | Green | Green | Green | Red | Off |
| 5 | Green | Green | Green | Green | Off |

## How it works

The main loop checks for keyboard input and updates the power level. When the level changes, the program redraws the bar and updates the icon colors through palette entries. The loop also checks the warning state; a counter controls the flashing delay. Drawing subroutines create the icons using rectangles, lines, a circle, and stored image masks.

The image-mask routines and some drawing routines are based on the MustyV I/O guide and course lecture examples, as noted in the source code.
