.equ FB,      0x20000000
.equ PAL,     0x21000000
.equ PRESENT, 0x21001008
.equ W,       192
.equ H,       144

.data
#drawing from Musty IO
# Register color overrides (UI only; safe comments for any assembler)
# @color t0 #fb7185    # pointer / address
# @color t1 #f59e0b    # counter / index
# @color t2 #eab308    # limit / size
# @color t3 #84cc16    # working value
# @color s0 #60a5fa    # saved state / position
# @color s1 #818cf8    # second saved value
# @color a0 #fbbf24    # argument / result

lightbulb_clipart:                    # PARTIAL image: 20 x 30 pixels, 3 bytes per row
    .byte 20, 30
    .byte 0x01, 0xF8, 0x00   # .......######.......
    .byte 0x06, 0x06, 0x00   # .....##......##.....
    .byte 0x18, 0x01, 0x80   # ...##..........##...
    .byte 0x20, 0x00, 0x40   # ..#..............#..
    .byte 0x20, 0x00, 0x40   # ..#..............#..
    .byte 0x40, 0x00, 0x20   # .#................#.
    .byte 0x40, 0x00, 0x20   # .#................#.
    .byte 0x80, 0x00, 0x10   # #..................#
    .byte 0x80, 0x00, 0x10   # #..................#
    .byte 0x80, 0x00, 0x10   # #..................#
    .byte 0x80, 0x00, 0x10   # #..................#
    .byte 0x80, 0x00, 0x10   # #..................#
    .byte 0x80, 0x00, 0x10   # #..................#
    .byte 0x40, 0x00, 0x20   # .#................#.
    .byte 0x40, 0x00, 0x20   # .#................#.
    .byte 0x20, 0x00, 0x40   # ..#..............#..
    .byte 0x10, 0x00, 0x80   # ...#............#...
    .byte 0x18, 0x00, 0x80   # ...##...........#...
    .byte 0x08, 0x01, 0x00   # ....#..........#....
    .byte 0x04, 0x02, 0x00   # .....#........#.....
    .byte 0x04, 0x02, 0x00   # .....#........#.....
    .byte 0x04, 0x02, 0x00   # .....#........#.....
    .byte 0x04, 0x02, 0x00   # .....#........#.....
    .byte 0x04, 0x02, 0x00   # .....#........#.....
    .byte 0x02, 0x04, 0x00   # ......#......#......
    .byte 0x03, 0x1C, 0x00   # ......##...###......
    .byte 0x03, 0xF4, 0x00   # ......######.#......
    .byte 0x02, 0x04, 0x00   # ......#......#......
    .byte 0x01, 0x08, 0x00   # .......#....#.......
    .byte 0x00, 0xF0, 0x00   # ........####........


#draw Icons begins
#Each icon has its own palette number to maximize efficiency 
#Fridge (Palette[5]), TV (Palette[6]), Lights (Palette[7]), AC (Palette[8])
#white space was used to create outline models 

#draws fridge icon (includes: fridge/freezer/handle)
drawFridge:
addi sp, sp, -16
sw ra, 12(sp)            #save return address
sw s0, 8(sp)            #save s0

#freezer section
li a0, 15
li a1, 20
li a2, 35
li a3, 15
li a4, 5          #palette 5 for fridge 
call drawRect

#freezer white space
li a0, 16
li a1, 21
li a2, 33
li a3, 13
li a4, 4
call drawRect

#freezer handle
li a0, 18
li a1, 23
li a2, 1
li a3, 8
li a4, 5          #palette 5 for fridge 
call drawRect

#fridge section
li a0, 15
li a1, 34
li a2, 35
li a3, 23
li a4, 5          #palette 5 for fridge 
call drawRect

#fridge white space
li a0, 16
li a1, 35
li a2, 33
li a3, 21
li a4, 4
call drawRect

#fridge handle
li a0, 18
li a1, 39
li a2, 1
li a3, 13
li a4, 5          #palette 5 for fridge 
call drawRect

lw s0, 8(sp)      #restore s0
lw ra, 12(sp)     #restore return address
addi sp, sp, 16   #restore sp
ret







#draws TV icon (includes: box, screen, legs, and antenna)
drawTv:
addi sp, sp, -16
sw ra, 12(sp)            #save return address
sw s0, 8(sp)            #save s0

#tv box
li a0, 70
li a1, 25
li a2, 32
li a3, 32
li a4, 6          #palette 6 for tv
call drawRect

#tv screen
li a0, 71
li a1, 26
li a2, 30
li a3, 29
li a4, 4
call drawRect

#tv leg1
li a0, 76
li a1, 57
li a2, 3
li a3, 1
li a4, 6          #palette 6 for tv
call drawRect

#tv leg2
li a0, 93
li a1, 57
li a2, 3
li a3, 1
li a4, 6          #palette 6 for tv
call drawRect

#tv antenna1 top
li a0, 82
li a1, 24
li a2, 10         #length
li a3, -1         #diagonal left
li a4, 6          #palette 6 for tv
call drawDiagonal

#tv antenna2 top
li a0, 89
li a1, 24
li a2, 10
li a3, 1         # diagonal right
li a4, 6          #palette 6 for tv
call drawDiagonal

lw s0, 8(sp)      #restore s0
lw ra, 12(sp)     #restore return address
addi sp, sp, 16   #restore sp
ret




#draws lightbulb
#created using bitmap image
drawLights:
addi sp, sp, -16
sw ra, 12(sp)            #save return address
sw s0, 8(sp)            #save s0

#(a0 = x, a1 = y, a2 = drawing address, a3 = palette index)
#lightbulb
li a0, 22                 
li a1, 76                 
la a2, lightbulb_clipart  
li a3, 7          #palette 7 for lights
call drawMask

lw s0, 8(sp)      #restore s0
lw ra, 12(sp)     #restore return address
addi sp, sp, 16   #restore sp
ret







#draws AC icon (includes: outline, vents, and fan)
drawAC:
addi sp, sp, -16
sw ra, 12(sp)            #save return address
sw s0, 8(sp)            #save s0

#AC outline
li a0, 70
li a1, 75
li a2, 32
li a3, 32
li a4, 8          #palette 8 for AC
call drawRect

#AC white space
li a0, 71
li a1, 76
li a2, 30
li a3, 30
li a4, 4
call drawRect

#AC vents left
li a0, 72
li a1, 78
li a2, 5
li a3, 1
li a4, 8          #palette 8 for AC
call drawRect

#AC vents left bottom
li a0, 72
li a1, 103
li a2, 5
li a3, 1
li a4, 8          #palette 8 for AC
call drawRect

#AC vents right
li a0, 95
li a1, 78
li a2, 5
li a3, 1
li a4, 8          #palette 8 for AC
call drawRect

#AC vents right bottom
li a0, 95
li a1, 103
li a2, 5
li a3, 1
li a4, 8          #palette 8 for AC
call drawRect

#AC center
li a0, 85
li a1, 90
li a2, 7
li a3, 8
call drawCircle

#AC fan
li a0, 85
li a1, 84
li a2, 1
li a3, 13
li a4, 8
call drawRect

li a0, 78
li a1, 90
li a2, 15
li a3, 1
li a4, 8
call drawRect

lw s0, 8(sp)      #restore s0
lw ra, 12(sp)     #restore return address
addi sp, sp, 16   #restore sp
ret










#updating icon color
#(a0=palette number a1=on/off  1=Green, 0=Red, Black for other values)
setColor:
li t0, 0xFF0000             # Loads red at start
beqz a1, saveColor          # If input is 0, keep Red (Checking on off)

li t0, 0x33CC33
li t1, 1
beq a1, t1, saveColor       # If input is 1, then set icons to Green, else set to Black
li t0, 0                    

saveColor:
li t1, 4                 #4 bytes
mul t1, a0, t1          #offset = palette number * 4
li t2, PAL               #start of palette
add t1, t1, t2          #palette slot address
sw t0, 0(t1)            #store color in palette slot 
ret


#diagonal loop
#drawDiagonal(a0=x, a1=y, a2=length, a3=dx (1=right, -1=left), a4=palette index)
#draws a line going UP from(x,y)
#used to draw tv antenna
drawDiagonal:
    addi sp, sp, -24      #stack will use 6 registers (24 bytes)
    sw   ra, 20(sp)       #saves return address
    sw   s1, 16(sp)       #saves s1 (x)
    sw   s2, 12(sp)       #saves s2 (y)
    sw   s3, 8(sp)        #saves s3 (length)
    sw   s4, 4(sp)        #saves s4 (direction)
    sw   s5, 0(sp)        #saves s5 (color) 
    mv   s1, a0           # x
    mv   s2, a1           # y
    mv   s3, a2           # pixels left to draw
    mv   s4, a3           # x step (+1 or -1)
    mv   s5, a4           # color

diag_loop:
    beqz s3, diag_done     #end when no pixels are left
    mv   a0, s1            # plot x
    mv   a1, s2            #plot y
    mv   a2, s5            #plot color
    call plot
    add  s1, s1, s4      # x += direction
    addi s2, s2, -1      # y goes up
    addi s3, s3, -1      #length -1
    j    diag_loop       #draw next pixel

diag_done:
    lw   ra, 20(sp)      #restore return address
    lw   s1, 16(sp)      #restore s1
    lw   s2, 12(sp)      #restore s2
    lw   s3, 8(sp)       #restore s3
    lw   s4, 4(sp)       #restore s4
    lw   s5, 0(sp)       #restore s5
    addi sp, sp, 24      #restore sp
    ret

#loops
#profs code from lecture slide: flag quiz practice
#drawRect(a0=x, a1=y, a2=width, a3=height, a4=palette index)
#draw rectangle
drawRect:
mv t0, a1         #start y
add t4, a1, a3   #end y

rect_y:
    bge  t0, t4, rect_done
    mv   t1, a0                #start x
    add  t5, a0, a2           #end x

rect_x:
    bge  t1, t5, rect_next_y
    li   t2, W
    mul  t2, t0, t2
    add  t2, t2, t1
    li   t3, FB
    add  t2, t2, t3
    sb   a4, 0(t2)
    addi t1, t1, 1
    j    rect_x

rect_next_y:
    addi t0, t0, 1
    j    rect_y

rect_done:
    ret

#profs code from lecture slides: Drawing with memory
#plot(a0=x, a1=y, a2=palette index)
plot:
    bltz a0, pr    #check if x<0
    li   t0, W
    bge  a0, t0, pr   #check if x<192
    bltz a1, pr       #check if y<0
    li   t0, H
    bge  a1, t0, pr     #check if y<144
    li   t0, W
    mul  t0, a1, t0       #y*w
    add  t0, t0, a0       #y*w + x
    li   t1, FB           #
    add  t0, t0, t1
    sb   a2, 0(t0)        #color
    ret
pr:
    ret

#profs code from lecture slides: Drawing with memory
#drawCircle(a0 = center x, a1 = center y, a2 = radius, a3 = palette index)
drawCircle:
addi sp, sp, -28
    sw   ra, 24(sp)      #save return address
    sw   s0, 20(sp)       #saves s0 = center x
    sw   s1, 16(sp)       #saves s1 = center y
    sw   s2, 12(sp)       #saves s2 = color
    sw   s3, 8(sp)        #saves s3 = x
    sw   s4, 4(sp)        #saves s4 = y
    sw   s5, 0(sp)        #saves update 1-r
    mv   s0, a0           #center x
    mv   s1, a1           #center y
    mv   s2, a3           #color
    li   s3, 0            #initially x=0
    mv   s4, a2           #initially y=r
    li   t0, 1
    sub  s5, t0, a2       #updates = 1-r

cl:
    blt  s4, s3, cd       #end when x>y
    add  a0, s0, s3       #plot mirrors
    add  a1, s1, s4
    mv   a2, s2
    call plot
    sub  a0, s0, s3
    add  a1, s1, s4
    mv   a2, s2
    call plot
    add  a0, s0, s3
    sub  a1, s1, s4
    mv   a2, s2
    call plot
    sub  a0, s0, s3
    sub  a1, s1, s4
    mv   a2, s2
    call plot
    add  a0, s0, s4
    add  a1, s1, s3
    mv   a2, s2
    call plot
    sub  a0, s0, s4
    add  a1, s1, s3
    mv   a2, s2
    call plot
    add  a0, s0, s4
    sub  a1, s1, s3
    mv   a2, s2
    call plot
    sub  a0, s0, s4
    sub  a1, s1, s3
    mv   a2, s2
    call plot
    bltz s5, cn
    sub  t0, s3, s4
    slli t0, t0, 1
    addi t0, t0, 5
    add  s5, s5, t0
    addi s4, s4, -1
    j    ci

cn:
    slli t0, s3, 1        #update
    addi t0, t0, 3
    add  s5, s5, t0

ci:
    addi s3, s3, 1      #x+=1
    j    cl

cd:
    lw   ra, 24(sp)     #restore return address 
    lw   s0, 20(sp)
    lw   s1, 16(sp)
    lw   s2, 12(sp)
    lw   s3, 8(sp)
    lw   s4, 4(sp)
    lw   s5, 0(sp)
    addi sp, sp, 28     #restore sp
    ret

#lightbulb functions from Musty IO
drawMask:
    lbu  t0, 0(a2)            # width
    lbu  t1, 1(a2)            # height
    addi a2, a2, 2            # a2 -> first row
    addi t2, t0, 7
    srli t2, t2, 3            # bytes per row
    li   t3, 0                # row
dm_row:
    bge  t3, t1, dm_done
    li   t4, 0                # column
dm_col:
    bge  t4, t0, dm_next
    srli t5, t4, 3            # which byte of the row: column / 8
    add  t5, a2, t5
    lbu  t5, 0(t5)
    andi t6, t4, 7            # which bit: column % 8, counted from the left
    li   a4, 0x80
    srl  a4, a4, t6
    and  t5, t5, a4
    beqz t5, dm_skip          # 0 bit: transparent
    add  t5, a1, t3           # screen y = y + row
    li   t6, W
    mul  t5, t5, t6
    add  t5, t5, a0           # + x
    add  t5, t5, t4           # + column
    li   t6, FB
    add  t5, t5, t6
    sb   a3, 0(t5)
dm_skip:
    addi t4, t4, 1
    j    dm_col
dm_next:
    add  a2, a2, t2           # next mask row
    addi t3, t3, 1
    j    dm_row
dm_done:
    ret

# profs code: setPalette(a0 = table of 0xRRGGBB words, a1 = count, a2 = first palette index)
setPalette:
    slli t0, a2, 2            # 4 bytes per palette entry
    li   t1, PAL
    add  t1, t1, t0
sp_loop:
    beqz a1, sp_done
    lw   t0, 0(a0)
    sw   t0, 0(t1)
    addi a0, a0, 4
    addi t1, t1, 4
    addi a1, a1, -1
    j    sp_loop
sp_done:
    ret
 