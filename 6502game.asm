.org $8000 ;starts the rom from the address 8000

;6502 ADDRESS REFERENCES
.define POSXY       $00
.define OLDPOSXY    $01
.define POINTS      $02
.define SACCV       $10 ;SAVE ACCOMULATOR VALUE ( FOR ROUTINES )
.define VRAM       $0200 ;SAVE ACCOMULATOR VALUE ( FOR ROUTINES )

;KEYS
.define UP      #$01
.define DOWN    #$02
.define LEFT    #$04
.define RIGHT   #$08
.define SPACE   #$20

;COLORS
.define MUDCOLOR         #$03
.define CLEARCOLOR       #$06
.define PLAYERCOLOR      #$0B
.define LOADINGCOLOR     #$0A

begin:
LDA #$01 ;exadecimal
STA $0200
LDA #02 ;decimal
STA $02FF
LDA #$04 
STA $020F
LDA #$0D
STA $02F0

JSR clear_zero_page
JSR clear_screen
JSR draw_player

game_loop:

JSR player_movement
JSR calculate_points
JSR draw_player

JMP game_loop

draw_player:
STA SACCV
LDA PLAYERCOLOR
LDX POSXY
STA VRAM,X
LDA OLDPOSXY
CMP POSXY
BNE clear_old_player_pos
LDA SACCV
RTS

calculate_points:
STA SACCV
LDX POSXY
LDA VRAM,X
CMP MUDCOLOR
BEQ increase_points
RTS

increase_points:
LDX POINTS
INX
STX POINTS
RTS
LDA SACCV
RTS

clear_old_player_pos:
LDA CLEARCOLOR
LDX OLDPOSXY
STA VRAM,X
RTS

player_movement:
LDA $4000
BEQ player_movement
JSR save_old_player_pos
CMP LEFT
BEQ move_left
CMP RIGHT
BEQ move_right
CMP UP
BEQ move_up
CMP DOWN
BEQ move_down
RTS

move_left:
DEC POSXY
RTS

move_right:
INC POSXY
RTS

move_up:
STA SACCV
LDA POSXY
SBC #16
STA POSXY
LDA SACCV
RTS

move_down:
STA SACCV
LDA POSXY
CLC
ADC #16
STA POSXY
LDA SACCV
RTS

save_old_player_pos:
LDX POSXY
STX OLDPOSXY
RTS

clear_screen:
LDX #0
clear_screen_loop:
LDA LOADINGCOLOR
STA VRAM,X
LDA MUDCOLOR
STA VRAM,X
INX
BNE clear_screen_loop
RTS

clear_zero_page:
LDX #0
LDA #0 ; this is the value to write
clear_zero_page_loop:
STA $00, X
INX
BNE clear_zero_page_loop
RTS

vsync:
RTI

irq:
RTI

.goto $FFFA

.dw vsync ;NMI
.dw begin ;RESET
.dw irq ;IRQ/BRK