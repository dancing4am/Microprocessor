/*
*   FILE          : cj_hook.c
*   PROJECT       : SENG2010 Assingment 3 - Blinking Lights
*   NAME          : Chowon Jung
*   DESCRIPTION   : This file is C to assembler menu cj_hook.
*/

// Library
#include <stdio.h>
#include <stdint.h>
#include <ctype.h>

#include "common.h"

// Variable
uint32_t count;   // number of LED loop cycle
uint32_t delay;   // delay time between each LED
char* dest;

uint32_t gameDelay; // delay time between each LED
char* pattern;      // LED lightening pattern
uint32_t target;    // target LED to be catched

int fetch_count;  // container of user input for count
int fetch_delay;  // container of user input for delay
char fetch_status; // container of argument user entered

int fetch_gameDelay;  // container of user input for delay
int fetch_pattern;    // container of user input for pattern
int fetch_target;     // container of user input for target

// Assembly Prototype Prototype
int cj_led_demo(int count, int delay);
int cj_game(int gameDelay, char* pattern, int target);
int string_test(char *p);

/*
*   Function      : cjA2()
*   Description   : This function is used to perform LED lightening cycle
*                   by given number from user with given delay time from user.
*                   If no argument is given, performs with default values.
*   Parameter     : int action  : check if to display description or to function
*   Return        : void
*/
void cjA2(int action)
{
  // display command description if asked to
  if(action==CMD_SHORT_HELP) return;
  if(action==CMD_LONG_HELP){
    printf("Sing Me a Song Function\n\n"
          "This command sings <Yellow> by Coldplay.\n"
        );
    return;
  }

  // fetch arguments if asked to run the command
  fetch_count = fetch_uint32_arg(&count);
  fetch_delay = fetch_uint32_arg(&delay);

  // if no count is given
  if (fetch_count) {
    // use a default count value
    count = 0x12;
  }

  // if no delay time is given
  if (fetch_delay) {
    // use a default delay value
    delay = 0x8FF00;
  }

  // call LED lightening function with given values
  printf("\n    Look at the stars, look how they shine for you :)\n\n");
  cj_led_demo(count, delay);
}

// add & enable command on prompt
ADD_CMD("sing_me_a_song", cjA2,"Test the new Sing Me a Song function")



/*
*   Function      : cjA3()
*   Description   : This function is used to perform LED lightening cycle
*                   by given pattern from user with given delay time from user.
*                   The target of the game is also given by the user to play
*                   the game and the user wins when the user button is pushed
*                   at the time the target LED is lightening.
*                   If no argument is given, performs with default values.
*   Parameter     : int action  : check if to display description or to function
*   Return        : void
*/
void cjA3(int action)
{
  // display command description if asked to
  if(action==CMD_SHORT_HELP) return;
  if(action==CMD_LONG_HELP){
    printf("cjGame Function\n\n"
          "This command runs the game <Blinking Lights>.\n"
        );
    return;
  }

  // fetch arguments if asked to run the command
  fetch_gameDelay = fetch_uint32_arg(&gameDelay);
  fetch_pattern = fetch_string_arg(&pattern);
  fetch_target = fetch_uint32_arg(&target);

  // if no gameDelay is given
  if (fetch_gameDelay) {
    // use a default gameDelay value
    gameDelay = 0x15E;
  }

  // if no pattern is given
  if (fetch_pattern) {
    // use a default pattern value
    pattern = "31024675";
  }

  // if no target is given
  if (fetch_target) {
    // use a default target value
    target = 1;
  }

  // call LED lightening game function with given values
  printf("\n    Catch me if you can!!! :P\n\n");
  cj_game(gameDelay, pattern, target);
}

// add & enable command on prompt
ADD_CMD("cjGame", cjA3,"Start playing the <Blinking Lights> game")



void cj_string_test(int action)
{
  // display command description if asked to
  if(action==CMD_SHORT_HELP) return;
  if(action==CMD_LONG_HELP){
    printf("String testFunction\n\n"
          "This command tests string input.\n"
        );
    return;
  }

  fetch_status = fetch_string_arg(&dest);

  if (fetch_status){
    printf("\nYou have not entered any arguments! :O\n");
    return;
  }

  printf("\n%d\n", string_test(&fetch_status));

}
// add & enable command on prompt
ADD_CMD("stest", cj_string_test, "Test string yay")
