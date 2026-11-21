.text
## INITIALIZE REGISTERS/MEMORY
## Set up the colors and registers
main:
## Set Up Color Palette
     li t0, 0x21000000   #Palette

     li t1,0             #Black
     sw t1,0(t0)         #Color index 0

     li t1, 0xFFFFFF     #White
     sw t1, 16(t0)       #Color index 4

     li t1, 0xFF0000     #Red
     sw t1, 40(t0)       # Color index 10

     li t1, 0xFFFF00     #Yellow
     sw t1, 44(t0)       #Color index 11

     li t1, 0xFFA500     #Orange
     sw t1, 48(t0)       #Color index 12

     li t1, 0x90EE90     #lLight green
     sw t1, 52(t0)       #Color index 13

     li t1, 0x00FF00     #Green
     sw t1, 56(t0)       #Color index 14

## Saved Registers for Keyboard and Bar Level
     li s0, 0x20000000   #Screen memory
     li s1, 0x4000002C   #Keyboard input
     li s2, 0            #Power level: 0 to 5


## Draw Bar/Slider
     call draw_bar  # Draw inital empty bar

## Available Key Input 
## Input either 'j' or 'k'
     li t1, 107                # 107= 'k'
     beq t0, t1, increase     # Go to "increase"

     li t1, 106                # 106= 'j' 
     beq t0, t1, decrease     # Go to "decrease"

## Input is neither 'j' or 'k'     
     j checkReserve       

## Increases Bar Level
increase:
## Checks that Bar Level doesn't go above 5
     li t1,5                    # Maximum level = 5
     bge s2, t1, checkReserve   # Checks that level >= 5

## Increase Level since Level < 5
     addi s2, s2, 1            # Increase Level
     call draw_bar             # Redraw Power Bar
     call updateIcons          # Update Icon Color

     j checkReserve            

## Decreases Bar Level
decrease:
## Checks that Bar Level doesn't go below 0
     beqz s2, checkReserve     # Checks that level = 0
      
## Decrease Level since Level > 0
     addi s2,s2, -1            # Decrease Level
     call draw_bar             # Redraw Power Bar
     call updateIcons          # Update Icon Color
    
     j checkReserve


## FUNCTION: DRAWS POWER LEVEL BAR 
## Calculate the filling and triangle digonal
draw_bar:
      #Each power level fills 40/5 rows
     li t1, 16
     mul t2, s2, t1        #Fill height = level *8

     li s4, 138              #Bottom boundary
     sub s4,s4, t2         # First filled Y  coordinate

     li t0,58               #start at Y=58

row_loop:
     li t1, 138              #end after Y=137
     bge t0, t1, draw_done

     # Calculate diagonal right edge
     # X = 102 + ((89 - Y)/2

     li t2, 137
     sub t2, t2, t0

     li t3,39
     mul t2, t2, t3           #Multiply by 19

     li t3,79
     div t2, t2, t3           #Divide by 39

     addi t2, t2, 146         #Right edge X

     li t3, 146                #starting X coordinate

##draw the pixels and select the color
col_loop:
     li t4, 186
     bge t3, t4, next_row   #finish  current row

     #Pixel address= base+Y*192+X

     li t5, 192
     mul t5, t0, t5           #Y*128
     add t5, t5, t3           #Add X
     add t5, t5, s0            #Screen Address

     li t6, 4                 #default = 7

     #Outside digonal = white
     blt t2, t3, draw_pixel

     #Inside triangle is gray
     li t6, 9

     #Top outline = black
     li a0, 58
     beq t0, a0, black_pixel

     #Left outline = black
     li a0, 146
     beq t3, a0, black_pixel

     #Digonal outline
     beq t3, t2, black_pixel

     #Above fill height = grey
     blt t0, s4, draw_pixel


     # Select fill color based on power
     # Level 1 = index 10 (red)
     # Level 2 = index 11 (yellow)
     # Level 3 = index 12 (orange)
     # Level 4 = index 13 (light green)
     # Level 5 = index 14 (green)

     addi t6, s2, 9       #Color index = level +9
     j draw_pixel

black_pixel:
     li t6, 0             #black outline color

draw_pixel:
     sb t6, 0(t5)         #Draw current pixel

     addi t3, t3,1        #move right
     j col_loop

next_row:
     addi t0, t0,1        #move down
     j row_loop          # Draw the next row

draw_done:
     li t4, 0x21001008     #Displa update address
     li t5,1
     sw t5, 0(t4)          #Request display update
     ret                    #RETURN TO KEY BOARD
