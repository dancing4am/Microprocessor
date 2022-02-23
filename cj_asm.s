@
@   FILE          : cj_asm.s
@   PROJECT       : SENG2010 Assingment 3 - Blinking Lights
@   NAME          : Chowon Jung
@   DESCRIPTION   : This file is used to provide LED lightening related functions
@                   and delay function.
@


  .code 16      @ This directive selects the instruction set being generated.
                @ The value 16 selects Thumb, with the value 32 selecting ARM.

  .text         @ Tell the assembler that the upcoming section is to be considered.
                @ assembly language instructions - Code section (text -> ROM)



@@ Function Header Block
  .align 2                @ Code alignment - 2^n alignment (n=2)
                          @ This causes the assembler to use 4 byte alignment

  .syntax unified         @ Sets the instruction set to the new unified ARM + Thumb
                          @ instructions. The default is divided (separate instruction sets)

  .global cj_led_demo     @ Make the symbol name for the function visible to the linker
  .global cj_game
  .global busy_delay
  .global string_test

  .code 16                @ 16bit THUMB code (BOTH .code and .thumb_func are required)
  .thumb_func             @ Specifies that the following symbol is the name of a Thumb
                          @ encoded function. Necessary for interlinking between ARM and THUMB code.





@ Function Declaration : int cj_led_demo(int count, int delay)
@
@ Input: r0, r1 (i.e r0 holds count, r1 holds delay)
@ Returns: r0
@

@ Here is the actual function

cj_led_demo:          @ sets environment for LED loop

    push {r4-r7, lr}  @ save way to go back & data in register 4 to 7

    mov r4, r0        @ save loop counter given

    mov r5, r1        @ save delay time given

cj_led_counter_loop:  @ set values to LEDs light for each

    mov r6, #7        @ set LED argument counter (LED is 0 ~ 7)

    mov r7, #8        @ set LED counter (+1 than LED for 0)

cj_led_shine_loop:        @ lightens LEDs by given cycle number and delay

    mov r0, r6            @ pass LED number to toggle

    bl   BSP_LED_Toggle   @ toggle LED

    mov r0, r5            @ pass argument for delay

    bl busy_delay         @ call delay function

    sub r6, r6, #1        @ change LED argument

    subs r7, r7, #1       @ decrement LED counter

    bgt cj_led_shine_loop     @ loop if any LED to be toggled left

    subs r4, r4, #1           @ decrement cycle counter

    bgt cj_led_counter_loop   @ loop if left loop cycle left

    mov r0, #0                @ return 0 (always successful)

    pop {r4-r7, lr}           @ restore the link reg and data in r4 to r7 were

    bx lr           @ Return (Branch eXchange) to the address in the link register (lr)






@ Function Declaration : int cj_game(int delay, char* pattern, int target)
@
@ Input: r0, r1, r2 (i.e r0 holds delay time, r1 holds blink pattern, r2 holds answer)
@ Returns: r0
@

@ Here is the actual function

cj_game:                  @ preserve, store data to proceed

    push {r3-r9, lr}      @ preserve previous data

    ldr r5, =0x38F        @ transfer into ms

    mul r5, r5, r0        @ store given delay

    mov r6, r1            @ store given pattern address

    mov r7, r2            @ store given target

pattern_prep:             @ set up offset to read pattern

    mov r8, r6            @ initialize pattern offset

    cmp r8, r6            @ it at first index

    beq led_on            @ skip offset adjustment

led_pattern:              @ turn off turned on LED, progress offset

    mov r0, r9            @ pass which LED to off

    bl BSP_LED_Off        @ turn off current LED

    add r8, r8, #1        @ move LED offset to the next one

    ldrb r9, [r8]         @ read current offset in

    cmp r9, 0             @ if at the end of pattern

    beq pattern_prep      @ restore offset

led_on:                   @ turn LED on following order

    ldrb r9, [r8]         @ read current offset

    sub r9, r9, #48       @ calculate which LED (atoi)

    mov r0, r9            @ pass which LED to on

    bl BSP_LED_On         @ turn on the LED

    mov r4, r5            @ give delay amount to the delay counter

btn_run:                  @ check if button pressed while delaying

    mov r0, #0            @ set user button to be tested

    bl BSP_PB_GetState    @ ask if user button is pressed

    cmp r0, #1            @ check if user button is NOT pressed

    beq btn_pressed       @ branch out if the button IS pressed

    mov r0, #1            @ if no button pressed, give single delay

    bl  busy_delay        @ call delay function

    subs r4, r4, #1       @ decrement delay count

    bgt btn_run           @ repeat if delay left

    cmp r4, #0            @ check if delay count left

    beq led_pattern       @ go to change LED if the delay term is over

btn_pressed:              @ when button is pressed

    mov r0, r9            @ set current LED to be turned off

    bl   BSP_LED_Off      @ turn current LED off

    cmp r9, r7            @ check if current LED equals given target

    beq win               @ branch if right LED

    mov r4, #20           @ assign number of toggle when lost

lose:                     @ blink target light when missed

    mov r0, r7            @ set target LED to be toggled

    bl  BSP_LED_Toggle    @ toggle LED

    ldr r0, =0xFFFFF      @ give user time to see LED

    bl  busy_delay        @ give delay

    subs r4, r4, #1       @ if not blinked long enough

    bgt lose              @ blink more

    cmp r4, #0            @ if blinked long enough

    beq game_end          @ exit

win:                      @ blink all LEDs when win

    mov r4, #4            @ give toggle number (4, blink twice)

congrats:                 @ prepare offset used for toggling LEDs on

    mov r5, #7            @ set LED argument counter

    mov r6, #8            @ set LED counter

led_loop:                 @ light all LEDs

    mov r0, r5            @ pass LED number to be toggled

    bl   BSP_LED_Toggle   @ toggle LED

    sub r5, r5, #1        @ change LED argument

    subs r6, r6, #1       @ decrement LED counter

    bgt led_loop          @ loop if any LED to be toggled left

    ldr r0, =0x9F7FFF     @ give delay between toggle

    bl    busy_delay      @ give delay

    subs r4, r4, #1       @ if counter to be toggled left

    bgt congrats          @ repeat toggle

game_end:                 @ exit

    mov r0, #0            @ return 0 (always successful)

    pop {r3-r9, lr}       @ restore the link reg and data in r4 to r9 were

    bx lr                 @ Return (Branch eXchange) to the address in the link register (lr)






@ Function Declaration : int busy_delay(int cycles)
@
@ Input: r0 (i.e r0 holds number of cycles to delay)
@ Returns: r0
@

@ Here is the actual function
busy_delay:

    push {r4}             @ save whatever in register 4 was

    mov r4, r0            @ get the amount of delay time given

delay_loop:               @ loop (delay) for given value long

    subs r4, r4, #1       @ decrement the value

    bgt delay_loop        @ repeat until 0 (until consume delay time given)

    mov r0, #0            @ return zero (always successful)

    pop {r4}              @ restore the value whatever in register 4 was

    bx lr                 @ return (Branch eXchange) to the address in the link register (lr)




@ Function Declaration : int string_test(char* p)
@
@ Input: r0 (i.e r0 holds user input string)
@ Returns: r0
@

@ Here is the actual function
string_test:

    ldrb r1, [r0]         @ Grab the content pointed to
    mov r0, r1

    bx lr



    .size cj_led_demo, .-cj_led_demo   @@ - symbol size (not req)

    .type cj_led_demo, %function    @Declares that the symbol is a function (not strictly required)
    .type cj_game, %function
    .type busy_delay, %function
    .type string_test, %function




@ Assembly file ended by single .end directive on its own line
.end
