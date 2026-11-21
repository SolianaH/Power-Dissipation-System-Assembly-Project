.equ FB,      0x20000000
.equ PAL,     0x21000000
.equ PRESENT, 0x21001008
.equ W,       192
.equ H,       144

.data
warning_clipart:                     # PARTIAL image: 36 x 32 pixels, 5 bytes per row
    .byte 36, 32
    .byte 0x00, 0x00, 0x60, 0x00, 0x00   # .................##.................
    .byte 0x00, 0x00, 0x60, 0x00, 0x00   # .................##.................
    .byte 0x00, 0x00, 0xF0, 0x00, 0x00   # ................####................
    .byte 0x00, 0x01, 0xF0, 0x00, 0x00   # ...............#####................
    .byte 0x00, 0x01, 0xF8, 0x00, 0x00   # ...............######...............
    .byte 0x00, 0x03, 0xB8, 0x00, 0x00   # ..............###.###...............
    .byte 0x00, 0x03, 0x9C, 0x00, 0x00   # ..............###..###..............
    .byte 0x00, 0x07, 0x0E, 0x00, 0x00   # .............###....###.............
    .byte 0x00, 0x07, 0x0E, 0x00, 0x00   # .............###....###.............
    .byte 0x00, 0x0E, 0x67, 0x00, 0x00   # ............###..##..###............
    .byte 0x00, 0x1C, 0xF7, 0x00, 0x00   # ...........###..####.###............
    .byte 0x00, 0x1D, 0xF3, 0x80, 0x00   # ...........###.#####..###...........
    .byte 0x00, 0x38, 0xF1, 0x80, 0x00   # ..........###...####...##...........
    .byte 0x00, 0x38, 0xF1, 0xC0, 0x00   # ..........###...####...###..........
    .byte 0x00, 0x70, 0xF0, 0xE0, 0x00   # .........###....####....###.........
    .byte 0x00, 0x60, 0xF0, 0xE0, 0x00   # .........##.....####....###.........
    .byte 0x00, 0xE0, 0xF0, 0x70, 0x00   # ........###.....####.....###........
    .byte 0x01, 0xC0, 0xF0, 0x70, 0x00   # .......###......####.....###........
    .byte 0x01, 0xC0, 0xE0, 0x38, 0x00   # .......###......###.......###.......
    .byte 0x03, 0x80, 0xE0, 0x1C, 0x00   # ......###.......###........###......
    .byte 0x03, 0x80, 0xE0, 0x1C, 0x00   # ......###.......###........###......
    .byte 0x07, 0x00, 0x60, 0x0E, 0x00   # .....###.........##.........###.....
    .byte 0x06, 0x00, 0x00, 0x0E, 0x00   # .....##.....................###.....
    .byte 0x0E, 0x00, 0x60, 0x07, 0x00   # ....###..........##..........###....
    .byte 0x1C, 0x00, 0xF0, 0x07, 0x00   # ...###..........####.........###....
    .byte 0x1C, 0x01, 0xF0, 0x03, 0x80   # ...###.........#####..........###...
    .byte 0x38, 0x00, 0xF0, 0x01, 0xC0   # ..###...........####...........###..
    .byte 0x38, 0x00, 0xE0, 0x01, 0xC0   # ..###...........###............###..
    .byte 0x70, 0x00, 0x00, 0x00, 0xE0   # .###............................###.
    .byte 0x60, 0x00, 0x00, 0x00, 0xE0   # .##.............................###.
    .byte 0xFF, 0xFF, 0xFF, 0xFF, 0xF0   # ####################################
    .byte 0xFF, 0xFF, 0xFF, 0xFF, 0xF0   # ####################################


     li s3, 0x40000028   #Keyboard state (Key Input or No Key Input)


## START: VISUAL SETUP
## Set up registers, background, initial icons, and bar
start:
## Necessary Registers for Warning Sign
     li s11, 0      # Counter for flashing warning (a delayed counter)
     li s10, 0      # Warning state (OFF = 0, ON = 1)
     li s9, 0xFFF   # Speed of Flashing Warning, Smaller Number = Faster, Larger Number = Slower

## Draw White Background
     li a0, 0       # x
     li a1, 0       # y
     li a2, 192     # Width
     li a3, 144     # Height
     li a4, 4       # White Color
     call drawRect   

## Draw All Four Icons
     call drawFridge
     call drawTv
     call drawLights
     call drawAC

     #icon on and off (OFF=0, ON=1)
     li a0, 5       #fridge pallet index
     li a1, 2       #initially black
     call setColor
 
     li a0, 6       #tv pallet index
     li a1, 2       #initially black
     call setColor

     li a0, 7       #lights pallet index
     li a1, 2       #initially black
     call setColor

     li a0, 8       #AC pallet index
     li a1, 2       #initially black
     call setColor


## MAIN KEYBOARD LOOP
## Continuously checks if there is a keyboard input or not
checkKeyboardState:
## Jump to checkReserve if No Key Input
     lw t0, 0(s3)              # Load state of keyboard (t0 = 0 means No Key Input, t0 = 1 means available Key Input)
     beqz t0, checkReserve     # Checks that there is no keyboard input

## Check Key Input Value
     lw t0, 0(s1)              # Read Keyboard Input


## FUNCTION: FLASHES WARNING SIGN
## Flash Warning Sign when Level (s2) is at 0 or 1, Turns off when Level 2-5)
checkReserve:
## checkReserve is needed to return to previous location
     call updateReserve         
     j checkKeyboardState

## Goes through different conditions for Flashing Warning Sign
updateReserve:
     addi sp, sp, -16             # Store return address
     sw ra, 12(sp)

## Check 1: Is the level 2-5? If so, turn warning off
     li t0, 2
     bge s2, t0, reserveNormal    # Level >= 2?

     addi s11, s11, 1             # Increase counter for delayed flash of warning sign

## Check 2: Is the counter high enough? If not, continue
     blt s11, s9, reserveReturn   # Counter < Arbitrary Speed
   
     li s11, 0                    # Resets Counter
     xori s10, s10, 1             # Toggles the Warning Sign (OFF = 0, ON = 1)

## Check 3: Is the Warning Sign OFF? If so, erase the warning
     beqz s10, reserveOFF
     
## Displays the Warning Sign
reserveON:
     li a0, 130                   # X-Location
     li a1, 10                    # Y-Location
     la a2, warning_clipart       
     li a3, 0                     # Palette Index: Black
     call warning
     j reservePresent

## Displays Nothing if Level is 2-5
reserveNormal:
     li s11, 0                    # Resets Counter
     beqz s10, reserveReturn      # If Sign is OFF, continue. If Sign is ON, move to reserveOFF
     li s10, 0                    # Turns the Sign OFF

## Covers Warning Sign with White Box
reserveOFF:
     li a0, 130                   # X-Location    
     li a1, 10                    # Y-Location
     li a2, 40                    # X-Width
     li a3, 40                    # Y-Width
     li a4, 4                     # Palette Index: White
     call drawRect
     j reservePresent

## Presents Warning Sign or White Box
reservePresent:
     li t0, PRESENT
     li t1, 1
     sw t1, 0(t0)

## Return to instruction after call
reserveReturn:
     lw ra, 12(sp)                 # Loads return address
     addi sp, sp, 16
     ret


## FUNCTION: UPDATE ICON COLORS
# Icon colors will update when Bar Level Changes
updateIcons:
## Icon Black, Red, Green (Red=0, Green=1, Black = 2)
     addi sp, sp, -16         # Store return address
     sw ra, 12(sp)

## Checks what the Bar Level is and changes colors based on Level
     bnez s2, case1           # Check 1: Level = 0?   
     li s5, 2                 # Fridge = Black
     li s6, 2                 # TV = Black
     li s7, 2                 # Light = Black
     li s8, 2                 # AC = Black
     j drawAll

case1:
     li t1, 1      
     bne s2, t1, case2        # Check 2: Level = 1?
     li s5, 0                 # Fridge = Red
     li s6, 0                 # TV = Red
     li s7, 0                 # Light = Red
     li s8, 0                 # AC = Red
     j drawAll

case2:
     li t1, 2
     bne s2, t1, case3        # Check 3: Level = 2?
     li s5, 0                 # Fridge = Red
     li s6, 0                 # TV = Red
     li s7, 1                 # Light = Green
     li s8, 0                 # AC = Red
     j drawAll

case3:
     li t1, 3
     bne s2, t1, case4        # Check 4: Level = 3?
     li s5, 1                 # Fridge = Green
     li s6, 0                 # TV = Red
     li s7, 1                 # Light = Green
     li s8, 0                 # AC = Red
     j drawAll

case4:
     li t1, 4
     bne s2, t1, case5        # Check 5: Level = 4?
     li s5, 1                 # Fridge = Green
     li s6, 0                 # TV = Red
     li s7, 1                 # Light = Green
     li s8, 1                 # AC = Green
     j drawAll

case5:
     li t1, 5
     bne s2, t1, updateEnd    # Check 6: Level = 5?
     li s5, 1                 # Fridge = Green
     li s6, 1                 # TV = Green
     li s7, 1                 # Light = Green
     li s8, 1                 # AC = Green
     j drawAll

## FUNCTION: COLORS ICONS
## Icon color changes based on s5, s6, s7, s8
## s5 = Fridge Color, s6 = TV Color, s7 = Lights Color, s8 = AC Color
drawAll:
## Icon Black, Red, Green (Red=0, Green=1, Black = 2)
     li a0, 5                 # Fridge pallet index
     mv a1, s5                # Sets Fridge Color
     call setColor

     li a0, 6                 # TV pallet index
     mv a1, s6                # Sets TV Color
     call setColor

     li a0, 7                 # Lights pallet index
     mv a1, s7                # Sets Lights Color
     call setColor

     li a0, 8                 # AC pallet index
     mv a1, s8                # Sets AC Color
     call setColor

## Return to instruction after call
updateEnd:
     lw ra, 12(sp)            # Loads return address
     addi sp, sp, 16

     li t0, PRESENT           # Presents Icons
     li t1, 1
     sw t1, 0(t0)
     ret



## FUNCTION: IMAGE TO DATA CODE
## From MustyV IO Guide CPE 2300.html
# drawMask(a0 = x, a1 = y, a2 = mask address, a3 = palette index)
# PARTIAL image: mask = .byte width, height, then the rows. Each row is (width+7)/8 bytes,
# Bit 7 of the first byte is the leftmost pixel. 1 = paint a3, 0 = transparent (keep what is there).
warning:
     lbu  t0, 0(a2)            # width
     lbu  t1, 1(a2)            # height
     addi a2, a2, 2            # a2 -> first row
     addi t2, t0, 7
     srli t2, t2, 3            # bytes per row
     li   t3, 0                # row
dm_row1:
     bge  t3, t1, dm_done1
     li   t4, 0                # column
dm_col1:
     bge  t4, t0, dm_next1
     srli t5, t4, 3            # which byte of the row: column / 8
     add  t5, a2, t5
     lbu  t5, 0(t5)
     andi t6, t4, 7            # which bit: column % 8, counted from the left
     li   a4, 0x80
     srl  a4, a4, t6
     and  t5, t5, a4
     beqz t5, dm_skip1          # 0 bit: transparent
     add  t5, a1, t3           # screen y = y + row
     li   t6, W
     mul  t5, t5, t6
     add  t5, t5, a0           # + x
     add  t5, t5, t4           # + column
     li   t6, FB
     add  t5, t5, t6
     sb   a3, 0(t5)
dm_skip1:
     addi t4, t4, 1
     j    dm_col1
dm_next1:
     add  a2, a2, t2           # next mask row
     addi t3, t3, 1
     j    dm_row1
dm_done1:
     ret
