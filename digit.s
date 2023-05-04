        .data
        .word   0 : 40
Stack:

Colors: .word   0x000000        # background color (black)
        .word   0xffffff        # foreground color (white)

SelectColors: .word   0x000000        # background color (black)
              .word   0x0000ff        # foreground color (Blue)

DigitTable:
        .byte   ' ', 0,0,0,0,0,0,0,0,0,0,0,0
        .byte   '0', 0x7e,0xff,0xc3,0xc3,0xc3,0xc3,0xc3,0xc3,0xc3,0xc3,0xff,0x7e
        .byte   '1', 0x38,0x78,0xf8,0x18,0x18,0x18,0x18,0x18,0x18,0x18,0x18,0x18
        .byte   '2', 0x7e,0xff,0x83,0x06,0x0c,0x18,0x30,0x60,0xc0,0xc1,0xff,0x7e
        .byte   '3', 0x7e,0xff,0x83,0x03,0x03,0x1e,0x1e,0x03,0x03,0x83,0xff,0x7e
        .byte   '4', 0xc3,0xc3,0xc3,0xc3,0xc3,0xff,0x7f,0x03,0x03,0x03,0x03,0x03
        .byte   '5', 0xff,0xff,0xc0,0xc0,0xc0,0xfe,0x7f,0x03,0x03,0x83,0xff,0x7f
        .byte   '6', 0xc0,0xc0,0xc0,0xc0,0xc0,0xfe,0xfe,0xc3,0xc3,0xc3,0xff,0x7e
        .byte   '7', 0x7e,0xff,0x03,0x06,0x06,0x0c,0x0c,0x18,0x18,0x30,0x30,0x60
        .byte   '8', 0x7e,0xff,0xc3,0xc3,0xc3,0x7e,0x7e,0xc3,0xc3,0xc3,0xff,0x7e
        .byte   '9', 0x7e,0xff,0xc3,0xc3,0xc3,0x7f,0x7f,0x03,0x03,0x03,0x03,0x03
        .byte   '+', 0x00,0x00,0x00,0x18,0x18,0x7e,0x7e,0x18,0x18,0x00,0x00,0x00
        .byte   '-', 0x00,0x00,0x00,0x00,0x00,0x7e,0x7e,0x00,0x00,0x00,0x00,0x00
        .byte   '*', 0x00,0x00,0x00,0x66,0x3c,0x18,0x18,0x3c,0x66,0x00,0x00,0x00
        .byte   '/', 0x00,0x00,0x18,0x18,0x00,0x7e,0x7e,0x00,0x18,0x18,0x00,0x00
        .byte   '=', 0x00,0x00,0x00,0x00,0x7e,0x00,0x7e,0x00,0x00,0x00,0x00,0x00
        .byte   'A', 0x18,0x3c,0x66,0xc3,0xc3,0xc3,0xff,0xff,0xc3,0xc3,0xc3,0xc3
        .byte   'B', 0xfc,0xfe,0xc3,0xc3,0xc3,0xfe,0xfe,0xc3,0xc3,0xc3,0xfe,0xfc
        .byte   'C', 0x7e,0xff,0xc1,0xc0,0xc0,0xc0,0xc0,0xc0,0xc0,0xc1,0xff,0x7e
        .byte   'D', 0xfc,0xfe,0xc3,0xc3,0xc3,0xc3,0xc3,0xc3,0xc3,0xc3,0xfe,0xfc
        .byte   'E', 0xff,0xff,0xc0,0xc0,0xc0,0xfe,0xfe,0xc0,0xc0,0xc0,0xff,0xff
        .byte   'F', 0xff,0xff,0xc0,0xc0,0xc0,0xfe,0xfe,0xc0,0xc0,0xc0,0xc0,0xc0
        .byte   'T', 0xff,0xff,0x18,0x18,0x18,0x18,0x18,0x18,0x18,0x18,0x3c,0x3c
        .byte   'K', 0xc3,0xc3,0xc6,0xcc,0xd8,0xf0,0xf0,0xd8,0xcc,0xc6,0xc3,0xc3
        .byte   'M', 0x81,0xc3,0xe7,0xbd,0xbd,0xbd,0x99,0x99,0x81,0x81,0x81,0x81
        .byte   'G', 0x7e,0xff,0xc1,0xc0,0xc0,0xc0,0xc0,0xcf,0xc3,0xc3,0xff,0x7e
        .byte   'I', 0xff,0xff,0x1c,0x1c,0x1c,0x1c,0x1c,0x1c,0x1c,0x1c,0xff,0xff
        .byte   'H', 0xc3,0xc3,0xc3,0xc3,0xc3,0xff,0xff,0xc3,0xc3,0xc3,0xc3,0xc3
        .byte   'L', 0xe0,0xe0,0xe0,0xe0,0xe0,0xe0,0xe0,0xe0,0xe0,0xff,0xff,0xff
        .byte   'P', 0xfe,0xc6,0xc3,0xc3,0xc3,0xc6,0xfc,0xc0,0xc0,0xc0,0xc0,0xc0
        .byte   'R', 0xfc,0xc6,0xc3,0xc3,0xc6,0xfc,0xfc,0xf6,0xc3,0xc3,0xc3,0xc3
        .byte   'O', 0x7e,0x66,0xc3,0xc3,0xc3,0xc3,0xc3,0xc3,0xc3,0xc3,0x66,0x7e
        .byte   'U', 0xc3,0xc3,0xc3,0xc3,0xc3,0xc3,0xc3,0xc3,0xc3,0xc3,0x66,0x7e
        .byte   'W', 0x81,0x81,0x81,0x81,0x99,0x99,0xbd,0xbd,0xbd,0xe7,0xc3,0x81
        .byte   'S', 0x7e,0xc3,0xc3,0xc0,0x60,0x3c,0x06,0x03,0x03,0x03,0xc6,0x7e
        .byte   'N', 0xc1,0xc1,0xa1,0xa1,0x91,0x91,0x89,0x89,0x85,0x85,0x83,0x83
# add additional characters here....
# first byte is the ascii character
# next 12 bytes are the pixels that are "on" for each of the 12 lines
        .byte    0, 0,0,0,0,0,0,0,0,0,0,0,0




#  0x80----  ----0x08
#  0x40--- || ---0x04
#  0x20-- |||| --0x02
#  0x10- |||||| -0x01
#       ||||||||
#       84218421

#   1   ...xx...      0x18
#   2   ..xxxx..      0x3c
#   3   .xx..xx.      0x66
#   4   xx....xx      0xc3
#   5   xx....xx      0xc3
#   6   xx....xx      0xc3
#   7   xxxxxxxx      0xff
#   8   xxxxxxxx      0xff
#   9   xx....xx      0xc3
#  10   xx....xx      0xc3
#  11   xx....xx      0xc3
#  12   xx....xx      0xc3



Test1:  .asciiz "0123456789"
Test2:  .asciiz "+ - * / ="
Test3:  .asciiz "ABCDEF"

        .text
        la      $sp, Stack

        li      $a0, 1          # some test cases
        li      $a1, 2
        la      $a2, Test1
        jal     OutText

        li      $a0, 1
        li      $a1, 18
        la      $a2, Test2
        jal     OutText

        li      $a0, 1
        li      $a1, 34
        la      $a2, Test3
        jal     OutText

        li      $v0, 10         # program exit
        syscall


# OutText: display ascii characters on the bit mapped display
# $a0 = horizontal pixel co-ordinate (0-255)
# $a1 = vertical pixel co-ordinate (0-255)
# $a2 = pointer to asciiz text (to be displayed)
OutText:
        addiu   $sp, $sp, -24
        sw      $ra, 20($sp)

        li      $t8, 1          # line number in the digit array (1-12)
_text1:
        la      $t9, 0x10040000 # get the memory start address
        sll     $t0, $a0, 2     # assumes mars was configured as 256 x 256
        addu    $t9, $t9, $t0   # and 1 pixel width, 1 pixel height
        sll     $t0, $a1, 10    # (a0 * 4) + (a1 * 4 * 256)
        addu    $t9, $t9, $t0   # t9 = memory address for this pixel

        move    $t2, $a2        # t2 = pointer to the text string
_text2:
        lb      $t0, 0($t2)     # character to be displayed
        addiu   $t2, $t2, 1     # last character is a null
        beq     $t0, $zero, _text9

        la      $t3, DigitTable # find the character in the table
_text3:
        lb      $t4, 0($t3)     # get an entry from the table
        beq     $t4, $t0, _text4
        beq     $t4, $zero, _text4
        addiu   $t3, $t3, 13    # go to the next entry in the table
        j       _text3
_text4:
        addu    $t3, $t3, $t8   # t8 is the line number
        lb      $t4, 0($t3)     # bit map to be displayed

        sw      $zero, 0($t9)   # first pixel is black
        addiu   $t9, $t9, 4

        li      $t5, 8          # 8 bits to go out
_text5:
        la      $t7, Colors
        lw      $t7, 0($t7)     # assume black
        andi    $t6, $t4, 0x80  # mask out the bit (0=black, 1=white)
        beq     $t6, $zero, _text6
        la      $t7, Colors     # else it is white
        lw      $t7, 4($t7)
_text6:
        sw      $t7, 0($t9)     # write the pixel color
        addiu   $t9, $t9, 4     # go to the next memory position
        sll     $t4, $t4, 1     # and line number
        addiu   $t5, $t5, -1    # and decrement down (8,7,...0)
        bne     $t5, $zero, _text5

        sw      $zero, 0($t9)   # last pixel is black
        addiu   $t9, $t9, 4
        j       _text2          # go get another character

_text9:
        addiu   $a1, $a1, 1     # advance to the next line
        addiu   $t8, $t8, 1     # increment the digit array offset (1-12)
        bne     $t8, 13, _text1

        lw      $ra, 20($sp)
        addiu   $sp, $sp, 24
        jr      $ra


# SelectText: display ascii characters on the bit mapped display in Blue to show selection
# $a0 = horizontal pixel co-ordinate (0-255)
# $a1 = vertical pixel co-ordinate (0-255)
# $a2 = pointer to asciiz text (to be displayed)
SelectText:
        addiu   $sp, $sp, -24
        sw      $ra, 20($sp)

        li      $t8, 1          # line number in the digit array (1-12)
_selectText1:
        la      $t9, 0x10040000 # get the memory start address
        sll     $t0, $a0, 2     # assumes mars was configured as 256 x 256
        addu    $t9, $t9, $t0   # and 1 pixel width, 1 pixel height
        sll     $t0, $a1, 10    # (a0 * 4) + (a1 * 4 * 256)
        addu    $t9, $t9, $t0   # t9 = memory address for this pixel

        move    $t2, $a2        # t2 = pointer to the text string
_selectText2:
        lb      $t0, 0($t2)     # character to be displayed
        addiu   $t2, $t2, 1     # last character is a null
        beq     $t0, $zero, _selectText9

        la      $t3, DigitTable # find the character in the table
_selectText3:
        lb      $t4, 0($t3)     # get an entry from the table
        beq     $t4, $t0, _selectText4
        beq     $t4, $zero, _selectText4
        addiu   $t3, $t3, 13    # go to the next entry in the table
        j       _selectText3
_selectText4:
        addu    $t3, $t3, $t8   # t8 is the line number
        lb      $t4, 0($t3)     # bit map to be displayed

        sw      $zero, 0($t9)   # first pixel is black
        addiu   $t9, $t9, 4

        li      $t5, 8          # 8 bits to go out
_selectText5:
        la      $t7, SelectColors
        lw      $t7, 0($t7)     # assume black
        andi    $t6, $t4, 0x80  # mask out the bit (0=black, 1=white)
        beq     $t6, $zero, _selectText6
        la      $t7, SelectColors     # else it is white
        lw      $t7, 4($t7)
_selectText6:
        sw      $t7, 0($t9)     # write the pixel color
        addiu   $t9, $t9, 4     # go to the next memory position
        sll     $t4, $t4, 1     # and line number
        addiu   $t5, $t5, -1    # and decrement down (8,7,...0)
        bne     $t5, $zero, _selectText5

        sw      $zero, 0($t9)   # last pixel is black
        addiu   $t9, $t9, 4
        j       _selectText2          # go get another character

_selectText9:
        addiu   $a1, $a1, 1     # advance to the next line
        addiu   $t8, $t8, 1     # increment the digit array offset (1-12)
        bne     $t8, 13, _selectText1

        lw      $ra, 20($sp)
        addiu   $sp, $sp, 24
        jr      $ra