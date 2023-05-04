.data
   #### General Data ####
   # Making room in the stack for bitmap operations
   stack: .word   0 : 40
   # Time limit for players turn - 15 seconds
   limitLength: .word 15000
   # The players starting health points (HP)
   playerHP: .word 120
   # The Player starting magic points (MP)
   playerMP: .word 120
   # The enemy Orc starting HP
   orcHP: .word 100
   # Pause length
   pauseLength: .word 3000
   # Current Attacks for Player and Orc - defaults to normal attack
   currentAttack: .byte 0

   #### PPM Image Frame Loader ####
   # File info for PPM images
   # Pointer for the file - bypasses header, I know the image size because I made them in Photoshop
   filePointer: .word 15
   # Menu print switch
   MenuSwitch: .word -1
   # HP/MP bar and damage switch
   barSwitch: .word -1
   # Title image frame
   titleFileName: .asciiz "./images/IntroTitle_1.pbm"
   # Tutorial image frame
   tutorialFileName: .asciiz "./images/IntroTitle_2.pbm"
   # Menu windows
   menuFileName: .asciiz "./images/menulayout.pbm"
   # main battle frame
   mainBattleFileName: .asciiz "./images/mainPanel.pbm"
   # attack battle frame
   attackFileName: .asciiz "./images/physicalAttack.pbm"
   # Magic battle frame
   magicFileName: .asciiz "./images/MagicAttack.pbm"
   # Heal battle frame
   healFileName: .asciiz "./images/HealAttack.pbm"
   # Mega battle frame
   megaFileName: .asciiz "./images/MegaAttack.pbm"
   # Player (hero) wins battle frame
   playerWinsFileName: .asciiz "./images/playerWins.pbm"
   # Orc wins battle frame
   orcWinsFileName: .asciiz "./images/OrcWins.pbm"
   # End of game image frame
   endGameFileName: .asciiz "./images/endTitle.pbm"
   # PPM Image buffer
   FileBuffer: .byte 0:193563

   #### Tables ####
   # Player moves table - X, Y
   playerMenu:
      # key 1 = Attack
      .word 180, 170
      # Key 2 = Magic
      .word 180, 190
      # Key 3 = Heal
      .word 180, 210
      # Key 4 = Mega
      .word 180, 230
      
   # The placement of the health-barL: X, Y, Color
   healthBar:
      # HP Bar - Green (Left to right movement)
      .word 20, 190, 2
      # MP Bar - Blue
      .word 20, 230, 1
      # Damage HP bar - Red (right to left movement) 
      .word 140, 190, 3
      # Lost MP bar - Red 
      .word 140, 230, 3
      
   # Color array for holding hex values for the colors: red (r), green (g), blue (b) and yellow (y)
   # Used for colored menu bars
   colorTable:   
      .word 0x000000   # Black
      .word 0x0000ff   # Blue
      .word 0x00ff00   # Green
      .word 0xff0000   # Red
      .word 0xffff00   # Yellow (Green & Red)
      .word 0x00ffff   # Cyan (Blue & Green)
      .word 0xff00ff   # Megenta (Blue & Red)
      .word 0xffffff   # White
   
   # HP and MP text display table (X, Y)  
   HP_MP_Table:
      # HP Text
      .word 20, 175
      # MP Text
      .word 20, 215
      
   # Loads the X and Y position for the top message bar area
   messageBarTable: .word 68, 7
   
   # Holds the X, Y and dimensions of PPM images
   PPMTable:
       # Menu borders
      .byte 1, 1
      # Every other PPM image
      .byte 1, 25
      
   # The midi sound, the pitch and instrument
   midiTable:
       # Physical attack
      .word 61, 127
      # Magic attack
      .word 65, 38
      # Heal
      .word 68, 98
      # Mega
      .word 61, 118
      # Orc Attack
      .word 72, 127
      
   #### Message Bar Prompts ####
   # Text to print to menu tables
   attack: .asciiz "ATTACK"
   magic: .asciiz "MAGIC"
   heal: .asciiz "HEAL"
   mega: .asciiz "MEGA"
   HPText: .asciiz "HP"
   MPText: .asciiz "MP"
   
   newlinePrompt: "\n"
   playersTurnPrompt: .asciiz "HEROES TURN"
   orcTurnPrompt: .asciiz "ORCS TURN    "
   playerWinsPrompt: .asciiz "HERO WINS   "
   orcWinsPrompt: .asciiz "ORC WINS     "
   
   # Print on I/O screen with controls
   controls: .asciiz "Controls:\n1:Attack\n2:Magic (cost a litte HP and MP()\n3:Heal (cost MP)\n4:Mega Attack (Massive Orc damage - cost HP and MP)\n0:Select (confirm command)\n"

.text
.globl main

main:
   # Intro Title Card Image
   la $a0, titleFileName
   la $a1, FileBuffer 
   la $a2, FileBuffer 
   jal ppmFileHandler
   jal drawPPMImage
   
   # Tutorial Image
   la $a0, tutorialFileName
   la $a1, FileBuffer 
   la $a2, FileBuffer 
   jal ppmFileHandler
   jal drawPPMImage
   
   # Prints the commands on the I/O window as backup
   la $a0, controls
   # Setting seed
   li $v0, 4
   syscall
   
   # Pause to let user read the tutorial
   jal pause
   
   # Initial Set-up of gameplay graphics
   # Loading the menu border image
   la $a0, menuFileName
   la $a1, FileBuffer 
   la $a2, FileBuffer 
   jal ppmFileHandler
   
   jal drawPPMImage
   # Changing from menu drawing mode to animation frame mode
   li $t1, 99
   sw $t1, MenuSwitch
   
   # Loading the main battle image frame
   la $a0, mainBattleFileName
   la $a1, FileBuffer 
   la $a2, FileBuffer 
   jal ppmFileHandler
   # Loading main battle graphics image
   jal drawPPMImage
   
   # Setting the HP/MP bar drawer to initial set up mode
   li $t9, -1
   sw $t9, barSwitch
   
   # Drawing HP bar
   li $a0, 1
   jal healthBarLoader
   li $a3, 10
   jal drawBox
   
   # Drawing MP bar
   li $a0, 2
   jal healthBarLoader
   li $a3, 10
   jal drawBox
   
  # Drawing HP text
  li $a0, 1
  la $a2, HPText
  jal drawHPandMP
  
   # Drawing MP text
   li $a0, 2
   la $a2, MPText
   jal drawHPandMP
   
   # Draws menu
   jal DrawPlayersMenu
   
   # Main gameplay loop
   gameplayLoop:
      # "Turn Based System" Picks next actor
      jal turnBasedSystem
      
      # "Game Status Check" to check the Player's and Orc's HP
      # Prints out who is winner and jumps to exit
      jal gameStatusCheck
      
      j gameplayLoop
      
 # Exits out of the game
exit:
   # Changing to full screen print
   li $t1, -1
   sw $t1, MenuSwitch
   
   # Pause on the end card
   jal pause
   
   # display the exit image
   la $a0, endGameFileName
   la $a1, FileBuffer 
   la $a2, FileBuffer 
   jal ppmFileHandler
   jal drawPPMImage
   
   # End of game/program
   li $v0, 10
   syscall
   
# Used for printing number strings to screen - modified, I added more letters
.include "digit.s"
   
## Procedure: turnBasedSystem
## A random number is drawn and either the player or orc turn starts
turnBasedSystem:
   # Saving main variables to the stack
   addi $sp, $sp, -4
   sw $ra, 0($sp)
   
   # Selcting the actor - either the hero or orc's turn
   jal randomizer
   
   # Selecting the actors turn from randomized numbers
   bne $v0, 0, playersTurn
   beq $v0, 0, orcsTurn

# Reestablishes the stack and goes back to main
backToMain:
   
   # Reload the stack and return to main
   lw $ra, 0($sp)
   addi $sp, $sp, 4
   jr $ra

## Procedure: randomizer
## Generates a random number generator, used for selecting actors and damage multipliers for attacks
## Return: $v0 Random number generated
randomizer:
   # Setting seed based off curent time
   li $v0, 30
   syscall
   
   # Setting the seed from current time
   move $a1, $a0
   # Setting the i.d. of pseudorandom
   li $a0, 0
   # Setting seed
   li $v0, 40
   syscall
   
   # Setting upper bound of range
   li $a1, 3
   # Generating random int from range 0 to 2, 0 = Orc's turn, 1 or 2 = Players turn
   li $v0, 42
   syscall
   
   # Return the random number between 0 and 1 outer procedure 
   move $v0, $a0
   
   jr $ra
   
   
## Procedure: orcsTurn
## Attacks the hero (player) when it's turn
orcsTurn:
   # Message bar message
   jal messageBarLoader
   la $a2, orcTurnPrompt
   jal OutText
   
   # Pauses so the player knows what's happening
   jal pause
   
   # Randomized damage multiplier
   jal randomizer
   
   # Returns the random number between 0 and 3 outer procedure 
   addiu $v0, $v0, 1
   # Multiplies the results of the ramdomize for damage bonus
   mul $a0, $v0, 5
   
   # Plays Orc attack sound effect
   li $a0, 5
   jal midiLoader
   
   # Attacks player and updates players health
   lw $a3, playerHP
   subu $a3, $a3, $a0
   sw $a3, playerHP
   
   # Can't use jr $ra, because we branched here due to randomized order
   j backToMain

## Procedure: gameStatusCheck
## Checks the status of the players and orcs health, determines a winner
gameStatusCheck:
   # Saves the $ra, in case no one wins
   subi $sp, $sp, 4
   sw $ra, 0($sp)
	
   # Updates the bars based off damage received
   jal updateBars

   # Loading HP for player and orc
   lw $t0, playerHP
   lw $t1, orcHP
   
   # Determining who might have won
   blez $t1, playerWins
   blez $t0, OrcWins
   
   # If no one won, return back to main for another round
   lw $ra, 0($sp)
   addi $sp, $sp, 4 
   jr $ra

## Procedure: playerWins
## If the player wins, print the message on the message bar and exit
playerWins:
   # Player wins frame, clear orc off screen
   la $a0, playerWinsFileName
   la $a1, FileBuffer 
   la $a2, FileBuffer 
   jal ppmFileHandler
   jal drawPPMImage

   # Load victory message and message bar
   jal messageBarLoader
   la $a2, playerWinsPrompt
   jal OutText
   
   # End game
   j exit

## Procedure: OrcWins
## If the orc wins, print the message on the message bar and exit   
OrcWins:
   # orc wins frame, blood on screen
   la $a0, orcWinsFileName
   la $a1, FileBuffer 
   la $a2, FileBuffer 
   jal ppmFileHandler
   jal drawPPMImage
   
   # Load lost message
   jal messageBarLoader
   la $a2, orcWinsPrompt
   jal OutText
   
   # exit game - game over man, game over...
   j exit
 
## Procedure: updateBars
## Updates the player HP and MP bars to show damage received and magic lost through usage   
updateBars:
   # Saving $ra to stack
   subi $sp, $sp, 4
   sw $ra, 0($sp)
   
   # Updating HP
   li $a0, 3
   # Reload the health bar
   jal healthBarLoader
   lw $a3, playerHP
   # This insures that you can receive more damage than your max HP
   # Otherwise HP bar will go off screen when you butt gets kicked badly by the orc
   bltzal $a3, damageGreaterThanHundred
   # Sees the difference in current health v.s. nornal health
   subiu $a3, $a3, 120
   abs $a3, $a3
   # Setting the HP damage to the health bar
   li $t9, 1
   sw $t9, barSwitch
   jal drawBox
   
   
   # Updating MP - Same as the HP, no real need for comments
   li $a0, 4
   jal healthBarLoader
   lw $a3, playerMP
   bltzal $a3, damageGreaterThanHundred
   subiu $a3, $a3, 120
   abs $a3, $a3

   li $t9, 1
   sw $t9, barSwitch
   jal drawBox
   
   # Restoring stack
   lw $ra, 0($sp)
   addi $sp, $sp, 4 
   jr $ra

## Procedure: updateBars
## Helper Procedure: damageGreaterThanHundred
## Sets the HP or MP to 0, so the HP/MP bar will go completely red if zero      
damageGreaterThanHundred:
   li $a3, 0
   jr $ra

## Procedure: playersTurn
## Uses keyboard polling to receive commands from player
## Player has limited time to attack before timeout
playersTurn:
   # The players timelimit is set
   lw $s0, limitLength 
   # Get initial time
   li $v0, 30
   syscall
   # Setting initial time
   move $s1, $a0
   
   #Storing the time variables
   addiu $sp, $sp, -8
   sw $s0, 0($sp)
   sw $s1, 4($sp)
   
   # Loading message, telling player that it's their turn (heroes turns)
   jal messageBarLoader
   la $a2, playersTurnPrompt
   jal OutText
   
# Keyboard polling and input timer loop
charLoop:
   # Saving before branching
   lw $s0, 0($sp)
   lw $s1, 4($sp)
   # Getting current time
   li $v0, 30
   syscall
   # Finding elapsed time
   subu $s2, $a0, $s1
   # If elapsed time is less than time limit, restart loop
   bgtu $s2, $s0, timeOut

# User input polling check
userCheck:
   # Checks if input is there
   jal IsCharThere
   # No key input, loop and try another iteration
   beqz $v0, charLoop
   # Grab char element
   lui $t0, 0xFFFF
   # Char into $v0	
   lw $v0, 4($t0)	

   # check user input
   # If char less than zero or greater than 4,
   # Ignore and go back to the start of the loop
   bgt $v0, 52, charLoop
   blt $v0, 48, charLoop 
   
   # convert the number char input into an int value  
   addi $v0, $v0, -48
   
   # Saving before branching
   sw $s0, 0($sp)
   sw $s1, 4($sp)
      
   # Command actions, animations and sound effects
   # Branch if cursor if input is 1 = Attack
   beq $v0, 1, commandAttack
   # Branch if cursor if input is 2 = Magic
   beq $v0, 2, commandMagic
   # Branch if cursor if input is 3 = Heal
   beq $v0, 3, commandHeal
   # Branch if cursor if input is 4 = Mega
   beq $v0, 4, commandMega
   # Branch if cursor if input is 0 = Enter 
   beq $v0, 0, commandExecute
   # sound effect

   # Do another iteration, this is a fail-safe. One of the branches should have activated
   j charLoop

timeOut:
   # restore stack, prevents program counter issues
   addiu $sp, $sp, 8
   
   # Refreshing main battle graphics image
   la $a0, mainBattleFileName
   la $a1, FileBuffer 
   la $a2, FileBuffer 
   jal ppmFileHandler
   jal drawPPMImage
   
   # Back to main, 
   j backToMain

## Procedure: IsCharThere
## Checks the polling to see if new char input has occured
## Return: $v0: 0 no data, 1 is data is present
IsCharThere:
   # Loading control
   lui $t0, 0xFFFF
   # Retrieving the control data 
   lw $t1, ($t0)
   # Removing the bitmask
   andi $v0, $t1, 1
   # Return to main
   jr $ra
	
## Procedure: pause
## Causes the game to pause when displaying the number, time is dependent on skill level
## Input: $a0 The pause length specified by the user
pause:
   # $a0 set to user specified level
   lw $a0, pauseLength 
   move $t0, $a0 # moving to temp work array
   # Get initial time
   li $v0, 30
   syscall
   # Setting initial time
   move $t1, $a0
   
   # Time keeping loop
   pauseLoop:
      # Getting current time
      syscall
      # Finding elapsed time
      subu $t2, $a0, $t1
      # If elapsed time is less than time limit, restart loop
      bltu $t2, $t0, pauseLoop
      
   # Go back to main
   jr $ra
   
##############################################################################################
#####                                 Player Attacks/Moves                               #####    
##############################################################################################

## Procedure: commandAttack
## Draws the text for the command
## Input: $a0: Input for the text drawing  
commandAttack:
   # Redraws the player meny text
   jal DrawPlayersMenu
   
   # Redraws the text but in blue to show it's highlighted
   # Loads the text based of the text table   
   li $a0, 1
   li $a1, -1
   sb $a0, currentAttack
   jal drawAttack
   
   # Back to player loop
   j charLoop

## Procedure: commandMagic
## Draws the text for the command
## Input: $a0: Input for the text drawing     
commandMagic:
   # Similar to commandAttack but with different table preloads for magic
   jal DrawPlayersMenu
   
   li $a0, 2
   li $a1, -1
   sb $a0, currentAttack
   jal drawMagic
   
   j charLoop

## Procedure: commandHeal
## Draws the text for the command
## Input: $a0: Input for the text drawing           
commandHeal:
   # Similar to commandAttack but with different table preloads for heal
   jal DrawPlayersMenu
   
   li $a0, 3
   li $a1, -1
   sb $a0, currentAttack
   jal drawHeal
   
   j charLoop

## Procedure: commandMega
## Draws the text for the command
## Input: $a0: Input for the text drawing                 
commandMega:
   # Similar to commandAttack but with different table preloads for mega
   jal DrawPlayersMenu
   
   li $a0, 4
   li $a1, -1
   sb $a0, currentAttack
   jal drawMega
   
   j charLoop

## Procedure: commandExecute
## Preps the space for the execution of the players action        
commandExecute:
   # Redraws the menu text
   jal DrawPlayersMenu
   
   # Loads all the actors elements
   lb $t0, currentAttack
   lw $t1, playerHP
   lw $t2, playerMP
   lw $t3, orcHP
   
   # executes the proper actor action based on inputs
   beq $t0, 1, attackExecute
   beq $t0, 2, magicExecute
   beq $t0, 3, healExecute
   beq $t0, 4, megaExecute
   
### Helper Procedures below ####

## Helper Procedure: attackExecute
## Procedure: commandExecute
## Updates parameters, draws animation frames and based off physical attack to the Orc
attackExecute:
   # HP calculations
   subiu $t3, $t3, 15
   sw $t3, orcHP
   
   # Attack image frame loading
   la $a0, attackFileName
   la $a1, FileBuffer 
   la $a2, FileBuffer 
   jal ppmFileHandler
   jal drawPPMImage
   
   # Attack sound effect
   li $a0, 1
   jal midiLoader
   
   # Once attck has been execute, act the same as a timeout and reset everything
   j timeOut

## Helper Procedure: magicExecute
## Procedure: commandExecute
## Updates parameters, draws animation frames and Updates the parameters based off magic attack damage to the player and Orc
magicExecute:
   # Same as attackExecute, but with magic presets and table loads
   subiu $t1, $t1, 20
   subiu $t2, $t2, 30
   subiu $t3, $t3, 35
   sw $t1, playerHP
   sw $t2, playerMP
   sw $t3, orcHP
   
   # Magic image frame load
   la $a0, magicFileName
   la $a1, FileBuffer 
   la $a2, FileBuffer 
   jal ppmFileHandler
   jal drawPPMImage
   
   li $a0, 2
   jal midiLoader
   
   j timeOut

## Helper Procedure: healExecute
## Procedure: commandExecute
## Updates parameters, draws animation frames and Heals the player and drains MP from the player 
healExecute:
   # Same as attackExecute, but with heal presets and table loads
   addiu $t1, $t1, 20
   subiu $t2, $t2, 10
   sw $t1, playerHP
   sw $t2, playerMP
   
   # Setting the HP/MP bar drawer to initial set up mode
   li $t9, -1
   sw $t9, barSwitch
   
   # Redrawing HP bar when healed
   li $a0, 1
   jal healthBarLoader
   li $a3, 10
   jal drawBox
   
   # Heal frame
   la $a0, healFileName
   la $a1, FileBuffer 
   la $a2, FileBuffer 
   jal ppmFileHandler
   jal drawPPMImage

   li $a0, 3
   jal midiLoader
      
   j timeOut

## Helper Procedure: megaExecute
## Procedure: commandExecute
## Updates parameters, draws animation frames and deals massive damage to Orc, drains a lot of HP an MP         
megaExecute:
   # Same as attackExecute, but with mega presets and table loads
   subiu $t1, $t1, 50
   subiu $t2, $t2, 50
   subiu $t3, $t3, 75
   sw $t1, playerHP
   sw $t2, playerMP
   sw $t3, orcHP
   
   # Mega frame
   la $a0, megaFileName
   la $a1, FileBuffer 
   la $a2, FileBuffer 
   jal ppmFileHandler
   jal drawPPMImage
 
   li $a0, 4
   jal midiLoader
       
   j timeOut

   
##############################################################################################
#####                                 Graphics Section                                   #####    
##############################################################################################

## Procedure: DrawPlayersMenu
## Draws the player menu, used at start-up
DrawPlayersMenu:
   # Saves the $ra to main to stack
   addiu $sp, $sp, -4
   sw $ra, 0($sp)
   
   # Draws the attack text
   li $a0, 1
   li $a1, 0
   jal drawAttack
   
   # Draws the magic text
   li $a0, 2
   li $a1, 0
   jal drawMagic
   
   # Draws the heal text
   li $a0, 3
   li $a1, 0
   jal drawHeal
   
   # Draws the mega text
   li $a0, 4
   li $a1, 0
   jal drawMega
   
   # restore $ra to main
   lw $ra, 0($sp)
   addiu $sp, $sp, 4
   jr $ra
   
## Procedure: playerDrawLoader
## Loads the X,Y coordinates, text and colors for the player menu text from table
## Input: $a0 The player selection input int into table
## Return: $a0 The X coordinate
## Return: $a1 The Y coordinate 
playerDrawLoader:
   # Loading box-table and doing the pointer math
   la $t0, playerMenu
   move $t1, $a0
   subi $t1, $t1, 1
   mulu $t1, $t1, 8
   addu $t0, $t0, $t1
   
   # Loading draw parameters
   # X-coordinates
   lw $a0, 0($t0)
   # Y-coordinates
   lw $a1, 4($t0)
   # Return to main
   jr $ra
   
## Procedure: HPandMPLoader
## Loads the X,Y coordinates for the player HP/MP text from table
## Input: $a0 The player selection input char
## Return: $a0 The X coordinate
## Return: $a1 The Y coordinate 
HPandMPLoader:
   # Loading box-table and doing the pointer math
   la $t0, HP_MP_Table
   move $t1, $a0
   subi $t1, $t1, 1
   mulu $t1, $t1, 8
   addu $t0, $t0, $t1
   
   # Loading draw parameters
   # X-coordinates
   lw $a0, 0($t0)
   # Y-coordinates
   lw $a1, 4($t0)
   # Return to main
   jr $ra
   
## Procedure: healthBarLoader
## Loads the X,Y coordinates and colors for HP/MP bars from table
## Input: $a0 The player selection input char
## Return: $a0 The X coordinate
## Return: $a1 The Y coordinate 
## Return: $a2 The color of the bar
healthBarLoader:
   # Loading box-table and doing the pointer math
   la $t0, healthBar
   move $t1, $a0
   subi $t1, $t1, 1
   mulu $t1, $t1, 12
   addu $t0, $t0, $t1
   
   # Loading draw parameters
   # X-coordinates
   lw $a0, 0($t0)
   # Y-coordinates
   lw $a1, 4($t0)
   # color of bar
   lw $a2, 8($t0)
   # Return to main
   jr $ra
   
## Procedure: messageBarLoader
## Loads the X,Y coordinates for message bar from table 
## Return: $a0 The X coordinate
## Return: $a1 The Y coordinate 
messageBarLoader:
   # Loading box-table and doing the pointer math
   la $t0, messageBarTable
   
   # Loading draw parameters
   # X-coordinates
   lw $a0, 0($t0)
   # Y-coordinates
   lw $a1, 4($t0)
   # Return to main
   jr $ra
   
## Procedure: drawAttack
## Draws the command text, changes color depending if it's selected
## Input: $a0: The user chosen move
## Input: $a1 controls if the text will be highlight (blue < 0) or neutral (white >= 0)
drawAttack:
   # Store $ra to DrawPlayersMenu
   addiu $sp, $sp, -4
   sw $ra, 0($sp)
   
   # Loads values from table
   move $s0, $a1
   jal playerDrawLoader
   
   # Text to display
   la $a2, attack
   
   # Checks if it white (non-selected) or blue (selected) 
   bgezal $s0, OutText
   bltzal $s0, SelectText
   
   # restore $ra to DrawPlayersMenu
   lw $ra, 0($sp)
   addiu $sp, $sp, 4
   jr $ra

## Procedure: drawMagic
## Draws the command text, changes color depending if it's selected
## Input: $a0: The user chosen move
## Input: $a1 controls if the text will be highlight (blue < 0) or neutral (white >= 0)
drawMagic:
   # similiar to drawAttack but for magic presets, loads and values
   addiu $sp, $sp, -4
   sw $ra, 0($sp)
   
   move $s0, $a1
   jal playerDrawLoader
   # Text to display
   la $a2, magic
   bgezal $s0, OutText
   bltzal $s0, SelectText
   
   # restore $ra
   lw $ra, 0($sp)
   addiu $sp, $sp, 4
   jr $ra

## Procedure: drawHeal
## Draws the command text, changes color depending if it's selected
## Input: $a0: The user chosen move
## Input: $a1 controls if the text will be highlight (blue < 0) or neutral (white >= 0)
drawHeal:
   # similiar to drawAttack but for heal presets, loads and values
   # Store $ra
   addiu $sp, $sp, -4
   sw $ra, 0($sp)
   
   move $s0, $a1
   jal playerDrawLoader
   # Text to display
   la $a2, heal
   bgezal $s0, OutText
   bltzal $s0, SelectText
   
   # restore $ra
   lw $ra, 0($sp)
   addiu $sp, $sp, 4
   jr $ra

## Procedure: drawMega
## Draws the command text, changes color depending if it's selected
## Input: $a0: The user chosen move
## Input: $a1 controls if the text will be highlight (blue < 0) or neutral (white >= 0)
drawMega:   
   # similiar to drawAttack but for mega presets, loads and values
   # Store $ra
   addiu $sp, $sp, -4
   sw $ra, 0($sp)
   
   move $s0, $a1
   jal playerDrawLoader
   # Text to display
   la $a2, mega
   bgezal $s0, OutText
   bltzal $s0, SelectText
   
   # restore $ra
   lw $ra, 0($sp)
   addiu $sp, $sp, 4
   jr $ra 
   
## Procedure: drawHPandMP
## Draws the HP and MP text above bars
## Input: $a0 wheter to draw HP or MP
drawHPandMP:
   # Store $ra to DrawPlayersMenu
   addiu $sp, $sp, -4
   sw $ra, 0($sp)
   
   # Loads the values based off if its HP or MP
   jal HPandMPLoader
   
   # Loads the results if above or equal to zero
   bgezal $s0, OutText
   
   # restore $ra to DrawPlayersMenu
   lw $ra, 0($sp)
   addiu $sp, $sp, 4
   jr $ra
   
## Procedure: drawBox
## Draws the color box in the display
## Input: $a0 The X coordinate
## Input: $a1 The Y coordinate
## Input: $a2 The color number used for box drawing
## Input: $a3 The size of drawn box
drawBox:
   # Loads a sentinal, decides if it's drawing HP/MP bar or HP damage / MP lost 
   lw $t9, barSwitch
   # Saving values into stack for complete box drawing operations
   addi $sp, $sp, -24
   sw $ra, 12($sp)
   sw $a0, 0($sp)
   sw $a1, 4($sp)
   sw $a2, 8($sp)
   sw $a3, 20($sp)
   move $s0, $a3
   sw $s0, 16($sp)

# Decides if the drawing will be horizontal (HP or MP) or vertical (Damage)
  bltz $t9, horizontalLoop
  bgtz $t9, verticalLoop

# Used for drawing the HP and MP bars
horizontalLoop:
  jal drawHorzLine
  # Reloads the stack values to correct position
  lw $a0, 0($sp)
  lw $a1, 4($sp)
  lw $a2, 8($sp)
  lw $a3, 20($sp)
  lw $s0, 16($sp)

   # Increment the loop values
   addi $a1, $a1, 1
   sw $a1, 4($sp)
   addi $s0, $s0, -1
   sw $s0, 16($sp)
   bne $s0, $0, horizontalLoop
   j HPMPDrawexit
 
# Used for drawing the damage on HP or MP lost  
verticalLoop:
   # If no change, do nothing
   blez $s0, HPMPDrawexit
   jal drawVertLine

  # Reloads the stack values to correct position
  lw $a0, 0($sp)
  lw $a1, 4($sp)
  lw $a2, 8($sp)
  lw $a3, 20($sp)
  lw $s0, 16($sp)

   # Increment the loop values
   subi $a0, $a0, 1
   sw $a0, 0($sp)
   addi $s0, $s0, -1
   sw $s0, 16($sp)
   
   j verticalLoop
   
HPMPDrawexit:
   # Complete reload the stack
   lw $ra, 12($sp)
   addi $sp, $sp, 24
   addi $s0, $s0, 0

   jr $ra
   
## Procedure: drawDot:
## Draws a individual dot on the screen
## Input: $a0 The X coordinate
## Input: $a1 The Y coordinate
## Input: $a2 The color number
drawDot:
   # Saving elements onto the stack ($ap)
   addi $sp, $sp, -8
   sw $ra, 4($sp)
   sw $a2, 0($sp)
	
   # Calculates the address for drawing the dot
   jal calculateAddress
   lw $a2, 0($sp)
   sw $v0, 0($sp)
	
   # Gets the color from the color table
   jal getColor
   lw $v0, 0($sp)
	
   # Draws dot
   sw $v1, 0($v0)

   # Reload the stack
   lw $ra, 4($sp)
   addi $sp, $sp, 8
	
   jr $ra
	
## Procedure: calculateAddress
## Converts the X and Y coordinates to a associated memory address
## Input: $a0 The X coordinate
## Input: $a1 The Y coordinate
## Input: $v0 The memory address
calculateAddress:
   # Calculating the address based off the base offset
   sll $a0, $a0, 2
   sll $a1, $a1, 7
   sll $a1, $a1, 3
   add $a0, $a0, $a1
   
   # Offsetting from base
   addi $v0, $a0, 0x10040000

   jr $ra
	
## Procedure: getColor
## Gets the color based off the value ($a2) and the colorTable array
## Input: $a2 The color number between 0-7
getColor:
   # Loading the table	
   la $t0, colorTable

   # Shifting to find the table offset
   sll $a2, $a2, 2
   add $a2, $a2, $t0

   # Getting the color from table
   lw $v1, 0($a2)
   jr $ra
	
## Procedure: drawHorzLine
## Draws the horizontal line
## Input: $a0 The X coordinate
## Input: $a1 The Y coordinate
## Input: $a2 The color number for color table
drawHorzLine:
   # Saving values onto the stack for operations
   addi $sp, $sp, -16
   sw $ra, 12($sp)
   sw $a0, 0($sp)
   sw $a1, 4($sp)
   sw $a2, 8($sp)
   # Fixed length, HP and MP bars are always the same
   li $a3, 120
	
   # Draws horizontal rows
   horzLoop:
   jal drawDot

   # Reloading from the stack
   lw $a0, 0($sp)
   lw $a1, 4($sp)
   lw $a2, 8($sp)
	
   # Increment the loop registers
   addi $a0, $a0, 1
   sw $a0, 0($sp)
   addi $a3, $a3, -1
   bne $a3, $0, horzLoop

   # Reload the stack for caller
   lw $ra, 12($sp)
   addi $sp, $sp, 16

   jr $ra

## Procedure: drawVertLine
## Draw a vertical line on the bitmap display
## Input: $a0: The X coordinate
## Input: $a1: The Y coordinate
## Input: $a2: The color number for color table 
drawVertLine:
   # Saving elements to stack
   addi $sp, $sp, -16
   sw $ra, 12($sp)
   sw $a0, 0($sp)
   sw $a1, 4($sp)
   sw $a2, 8($sp)
   # Fixed length for vertical draw, HP and MP bars are always 10 pixels tall
   li $a3, 10

   # The vertical drawing loop
   vertLoop:
      jal drawDot

      # Loading elements to decrement
      lw $a0, 0($sp)
      lw $a1, 4($sp)
      lw $a2, 8($sp)

      # Incrementing and decrementing values
      addi $a1, $a1, 1
      sw $a1, 4($sp)
      addi $a3, $a3, -1
      bne $a3, $0, vertLoop

      # restoring the stack
      lw $ra, 12($sp)
      addi $sp, $sp, 16

     jr $ra
	
   
##############################################################################################
#####                          PPM Image Graphics Handler                                #####    
##############################################################################################  

## Procedure: ppmFileHandler
## Loads the file from path and loads data onto buffer
## Input: $a0 File path
## Input: $a1 File buffer that will hold the data
## Input: $a2: File buffer size
ppmFileHandler:
   # Saving the inputs onto the stack
   subi $sp, $sp, 8
   sw $a1, 0($sp)
   sw $a2, 4($sp)

   # Loading the file
   li $a1, 0
   li $v0, 13
   syscall
   
   move $s0, $v0
    	
   # Reloading the inputs from the stack
   lw $a1, 0($sp)
   lw $a2, 4($sp)
	
   #read the file
   li $v0, 14
   move $a0, $s0
   syscall

   # Close the file 
   li $v0, 16
   move $a0, $s0
   syscall
	
   # Reloading the stack
   addi $sp, $sp, 8
   jr $ra
 
## Procedure: loadingMenuImage
## DLoads image that will cover entire bitmap screen
loadingMenuImage:
   # Loading drawing parameters
   # X-coordinates
   li $a0, 1
   # Y-coordinates
   li $a1, 1
   # Image dimensions
   li $a3, 254
   # Return to main
   jr $ra

## Procedure: drawImagePixal
## Draws a individual dot on the screen
## Input: $a0 The X coordinate
## Input: $a1 The Y coordinate
## Input: $a2 The image buffer
drawImagePixal:
   # Saving to the stack
   addi $sp, $sp, -8
   sw $ra, 4($sp)
   sw $a2, 0($sp)
	
   # Calculates the address for drawing the pixal
   jal calculateAddress
   lw $a2, 0($sp)
   sw $v0, 0($sp)
	
   # Retrieves the pixal color data from the PPM image file
   jal getImagePixal
   lw $v0, 0($sp)
	
   # Draws the pixal
   sw $v1, 0($v0)

   # Reload the stack
   lw $ra, 4($sp)
   addi $sp, $sp, 8
	
   jr $ra
			
## Procedure: getImagePixal
## Loads the RGB data in hex from a PPM/PBM image file, concatinates the data and returns a hex
## Input: $a2: The image buffer
getImagePixal:
   # Moves the buffer to #$t0
   move $t0, $a2
   # Adds the offset from the file pointer label
   # This is done to slowly increment through the buffer as it draws line by line
   lw $t9, filePointer
   # Offset the buffer with the pointer
   addu $t0, $t0, $t9 
	
   # PPM/PBM binary data works in increments of three,
   # each position represents a Red (R), Green (G) or Blue (B) in hex
   # I bitmask the last 2 bytes and combine to create the color hex value to be drawn
   
   # Blue Hex Bytes
   # loads the hex binary byte
   lb $s0, 0($t0)
   # Bit masking - removing the last two hex bytes
   andi $s6, $s0, 0x000000FF
   # Shift left to make room for the next byte (Green bytes)
   sll $s7, $s6, 8
	
   # Green Hex Bytes
   # Sames as above
   lb $s0, 1($t0)
   andi $s6, $s0, 0x000000FF
   # Or the bytes to add it to the bytes collected above
   or $s7, $s7, $s6
   sll $s7, $s7, 8

   # Blue Hex Bytes
   lb $s0, 2($t0)
   andi $s6, $s0, 0x000000FF
   or $s7, $s7, $s6
	
   # Draws the collected hex bytes from the PPM/PBM image file to the bitmap
   move $v1, $s7

   # Increment the file buffer pointer, so we don't draw the same pixal twice
   addiu $t9, $t9, 3
   # Save the new location to the file pointer label
   sw $t9, filePointer
   # Return
   jr $ra
	
## Procedure: drawPPMRow
## Draws the horizontal line to screen length 254 pixals 
## Input: $a0 The X coordinate
## Input: $a1 The Y coordinate
## Input: $a2 The image buffer
drawPPMRow:
   # Length is fixed
   li $a3, 254
   
   # Saving values onto the stack for operations
   addi $sp, $sp, -16
   sw $ra, 12($sp)
   sw $a0, 0($sp)
   sw $a1, 4($sp)
   sw $a2, 8($sp)

   # Draws horizontal rows
   imageHorLoop:
   jal drawImagePixal

   # Reloading from the stack
   lw $a0, 0($sp)
   lw $a1, 4($sp)
   lw $a2, 8($sp)
	
   # Increment the loop registers
   addi $a0, $a0, 1
   sw $a0, 0($sp)
   addi $a3, $a3, -1
   bne $a3, $0, imageHorLoop

   # Reload the stack for caller
   lw $ra, 12($sp)
   addi $sp, $sp, 16

   jr $ra


## Procedure: drawPPMImage
## Draws the color box in the display
## Input: $a0 The X coordinate
## Input: $a1 The Y coordinate
## Input: $a2 The image-buffer
## Input: $a3 Dimensions (fixed, unless for the menu border lines or full screen images)
drawPPMImage:
   lw $s5, MenuSwitch
   li $a0, 1
   li $a1, 25
   # Loading menu image
   la $a2, FileBuffer
   li $a3, 130
   
   # Checks if the senintal value is -1
   # If so, load the screen wide image to bitmap
   # This merges two image displaying types into one procedure 
   addi $sp, $sp, 4 
   sw $ra, 0($sp)
   bltzal $s5, loadingMenuImage
   lw $ra, 0($sp)
   subi $sp, $sp, 4
      
   # Saving values into stack for complete box drawing operations
   addi $sp, $sp, -24
   sw $ra, 12($sp)
   sw $a0, 0($sp)
   sw $a1, 4($sp)
   sw $a2, 8($sp)
   sw $a3, 20($sp)
   move $s0, $a3
   sw $s0, 16($sp)

# The main box loop that draws the horizontal lines
imageLoop:
  jal drawPPMRow

  # Reloads the stack values to correct position
  lw $a0, 0($sp)
  lw $a1, 4($sp)
  lw $a2, 8($sp)
  lw $a3, 20($sp)
  lw $s0, 16($sp)

   # Increment the loop values
   addi $a1, $a1, 1
   sw $a1, 4($sp)
   addi $s0, $s0, -1
   sw $s0, 16($sp)
   bne $s0, $0, imageLoop

   # Complete reload the stack
   lw $ra, 12($sp)
   addi $sp, $sp, 24
   addi $s0, $s0, 0
   
   # Reloading file pointer default starting location
   li $t0, 15
   sw, $t0, filePointer

   jr $ra
   
##############################################################################################
#####                                    Midi Handler                                    #####    
##############################################################################################    
   
   
## Procedure: midiLoader
## Loads the MIDI values based off the number
## Input: $t0 The randomized or input color number 
midiLoader:
   # loading midi table and finding values
   la $t0, midiTable
   move $t1, $a0
   subi $t1, $t1, 1
   mulu $t1, $t1, 8
   addu $t0, $t0, $t1
   
   # Loading MIDI
   # Pitch
   lw $a0, 0($t0)
   # Duration matches game mode pause
   lw $a1, pauseLength
   # Instrument
   lw $a2, 4($t0)
   # Max Volume
   li $a3, 127
   # Play MIDI sound
   li $v0, 31
   syscall
   
   # Return to main
   jr $ra
